{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "wordcraft";
  version = "2026.10.09-a300702";

  # Download the prebuilt Linux AppImage.
  src = fetchurl {
    url = "https://github.com/storytold/wordcraft/releases/download/v0.5.0/wordcraft-0.5.0-linux-x86_64.AppImage";
    hash = "sha256-lHfqkt2e3yq5dL3jJZWEWyc3snskx6QGWctdzieydVE=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # Add additional runtime libraries only if the AppImage requires them.
  extraPkgs = pkgs: [ ];

  meta = {
    description = "WordCraft desktop application";
    homepage = "https://github.com/WordCraftTool/wordcraft";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    mainProgram = "wordcraft";
  };
}
