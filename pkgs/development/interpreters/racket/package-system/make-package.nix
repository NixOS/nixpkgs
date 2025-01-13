{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchgit,
  fetchFromGitHub,
}:

{
  source,
  ...
}@spec:

stdenvNoCC.mkDerivation (
  finalAttrs:

  let
    pkgName = spec.name or source.name;

    preAttrs =
      (
        if (spec ? version) then
          {
            pname = "racket-" + pkgName;
            inherit (spec) version;
          }
        else
          {
            name = "racket-" + pkgName;
          }
      )
      // {
        src =
          if source.method == "url" then
            fetchurl source.args
          else if source.method == "git" then
            fetchgit (
              lib.optionalAttrs (spec ? checksum) { rev = spec.checksum; }
              // source.args
              // lib.optionalAttrs (source ? path) {
                sparseCheckout = [ source.path ] ++ source.args.sparseCheckout or [ ];
              }
            )
          else if source.method == "github" then
            fetchFromGitHub (lib.optionalAttrs (spec ? checksum) { rev = spec.checksum; } // source.args)
          else
            lib.assertOneOf "source.method" source.method [
              "url"
              "git"
              "github"
            ];

        sourceRoot =
          lib.optionalString
            (
              builtins.elem source.method [
                "git"
                "github"
              ]
              && source ? path
            )
            (
              lib.path.subpath.join [
                finalAttrs.src.name
                source.path
              ]
            );

        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall

          dst=$out/share/racket-packages-archive
          mkdir -p $dst

          cp -prT . $dst/${pkgName}
          ${lib.optionalString (spec ? checksum) "echo ${spec.checksum} > $dst/${pkgName}/.CHECKSUM"}

          runHook postInstall
        '';
      };

    postAttrs = {
      passthru = {
        inherit spec;
      } // spec.derivationArgs.passthru or { };

      meta =
        lib.optionalAttrs (spec ? description) {
          description = "Racket package: " + spec.description;
        }
        // lib.optionalAttrs (spec ? license) {
          inherit (spec) license;
        }
        // spec.derivationArgs.meta or { };
    };
  in

  preAttrs // spec.derivationArgs or { } // postAttrs
)
