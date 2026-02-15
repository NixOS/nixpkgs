{
  lib,
  callPackage,
  stdenvNoCC,
}:

let
  root = ./.;

  mkLxgwFont =
    args@{
      name,
      fontName,
      repoName,
      suffix ? "ttf",
      ...
    }:
    stdenvNoCC.mkDerivation (
      {
        pname = "lxgw-${name}";

        dontUnpack = suffix == "ttf";

        installPhase = ''
          runHook preInstall
          ${
            if suffix == "ttf" then
              "install -Dm644 $src $out/share/fonts/truetype/${fontName}.ttf"
            else
              "find . -name '*.ttf' -exec install -Dt $out/share/fonts/truetype/${fontName} {} \\;"
          }
          runHook postInstall
        '';

        meta = {
          homepage = "https://github.com/lxgw/${repoName}";
          platforms = lib.platforms.all;
          maintainers = with lib.maintainers; [ chillcicada ];
        }
        // (args.meta or { });
      }
      // (removeAttrs args [
        "name"
        "suffix"
        "fontName"
        "repoName"
      ])
    );

  call = name: callPackage (root + "/${name}") { inherit mkLxgwFont; };
in

builtins.foldl' (acc: name: acc // (call name)) { } (
  lib.pipe root [
    builtins.readDir
    (lib.filterAttrs (_: type: type == "directory"))
    builtins.attrNames
  ]
)
