{
  lib,
  stdenvNoCC,
  fetchurl,
  installFonts,
}:

let
  releaseInfo = lib.trivial.importJSON ./manifests/release.json;
  fontsInfo = lib.trivial.importJSON ./manifests/fonts.json;
  checksums = lib.trivial.importJSON ./manifests/checksums.json;

  releaseVersion = lib.removePrefix "v" releaseInfo.tag_name;

  convertAttrName =
    name:
    let
      lowerName = lib.strings.toLower name;
    in
    if builtins.match "^[[:digit:]].*" lowerName != null then "_" + lowerName else lowerName;

  convertVersion =
    version: if builtins.match "^[[:digit:]].*" version != null then "+" + version else "";

  convertLicense = import ./convert-license.nix lib;

  makeNerdFont =
    {
      caskName,
      description,
      folderName,
      licenseId,
      patchedName,
      version,
      ...
    }:
    stdenvNoCC.mkDerivation {
      pname = "nerd-fonts-" + lib.strings.toLower caskName;
      version = releaseVersion + convertVersion version;

      src =
        let
          filename = folderName + ".tar.xz";
          url = "https://github.com/ryanoasis/nerd-fonts/releases/download/${releaseInfo.tag_name}/${filename}";
          sha256 = checksums.${filename};
        in
        fetchurl {
          inherit url sha256;
        };

      sourceRoot = ".";

      nativeBuildInputs = [ installFonts ];

      passthru = {
        inherit releaseVersion;
        updateScript = {
          command = ./update.py;
          supportedFeatures = [ "commit" ];
        };
      };

      meta = {
        description = "Nerd Fonts: " + description;
        license = lib.unique (
          (with lib.licenses; [
            # > Nerd Fonts source fonts, patched fonts, and folders with explicit OFL SIL files
            ofl
            # > Nerd Fonts original source code files (such as `.sh`, `.py`, `font-patcher` and others)
            mit
          ])
          ++ lib.toList (convertLicense licenseId)
        );
        homepage = "https://nerdfonts.com/";
        changelog = "https://github.com/ryanoasis/nerd-fonts/blob/${releaseInfo.tag_name}/changelog.md";
        platforms = lib.platforms.all;
        maintainers = with lib.maintainers; [
          doronbehar
          rc-zb
        ];
      };
    };

  nerdFonts = lib.trivial.pipe fontsInfo [
    (map (font: lib.nameValuePair (convertAttrName font.caskName) (makeNerdFont font)))
    builtins.listToAttrs
  ];
in

nerdFonts
