{
  lib,
  stdenvNoCC,
  bintools,
  racket,

  isTethered ? false,
}:

let
  buildPackages =
    selector:

    let
      subset = x: y: builtins.all (lib.flip builtins.elem y) x;

      findPackages =
        sel:
        if builtins.isFunction sel then
          sel racket.pkgs
        else if builtins.isList sel then
          sel
        else
          throw "unsupported selector: ${lib.generators.toPretty sel}";

      packages = findPackages selector;

      convertDepSpec =
        depSpec:
        if lib.isDerivation depSpec then
          depSpec
        else if builtins.isAttrs depSpec then
          racket.makePackage depSpec
        else if builtins.isString depSpec then
          lib.findSingle (p: p.spec.name or p.spec.source.name or null == depSpec)
            (throw "cannot find derivation named ${depSpec} in racket.pkgs")
            (throw "find more than one derivation named ${depSpec} in racket.pkgs")
            (builtins.filter lib.isDerivation (builtins.attrValues racket.pkgs))
        else
          throw "unsupported dependency: ${lib.generators.toPretty depSpec}";

      getClosure =
        roots:
        let
          deps = lib.pipe roots [
            (builtins.map (lib.attrByPath [ "spec" "dependencies" ] [ ]))
            builtins.concatLists
            (builtins.map convertDepSpec)
            lib.unique
          ];
        in
        if subset deps roots then roots else getClosure (lib.unique (roots ++ deps));

      helpers = builtins.path {
        path = ./build-helpers;
        name = "racket-packages-build-helpers";
      };
    in

    stdenvNoCC.mkDerivation (
      finalAttrs:
      (
        if isTethered then
          {
            pname = "racket-with-packages";
            inherit (racket) version;
          }
        else
          {
            name = "racket-packages";
          }
      )
      // {
        nativeBuildInputs = [
          bintools # helps us find libraries
          racket
        ];

        buildInputs = getClosure packages;

        dontUnpack = true;

        configurePhase = ''
          runHook preConfigure

          racket -U -l racket/base -t ${helpers}/stdenv.rkt -f - <<EOF
          ${if isTethered then "(write-config #:config (new-racket-config))" else "(write-config)"}
          EOF

          runHook postConfigure
        '';

        dontBuild = true;

        installPhase = ''
          runHook preInstall

          racket -G $out/etc/racket -U -u ${helpers}/install-packages.rkt

          runHook postInstall
        '';

      }
      // lib.optionalAttrs isTethered {
        passthru.withPackages = selector1: buildPackages (packages ++ findPackages selector1);
      }
    );
in

buildPackages
