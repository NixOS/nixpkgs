{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:

let
  pname = "xtool";
  version = "1.13.0";

  src =
    fetchurl
      {
        aarch64-linux = {
          url = "https://github.com/xtool-org/xtool/releases/download/${version}/xtool-aarch64.AppImage";
          hash = "sha256-/XfzfxHqXswv44ee6UiUyy5eJIQM57QQ695/JwPnNow=";
        };
        x86_64-linux = {
          url = "https://github.com/xtool-org/xtool/releases/download/${version}/xtool-x86_64.AppImage";
          hash = "sha256-eyXlXS5/+hGYIGr6Ndf1Xxnn4J0I/UoaU4SmZRyK8Sc=";
        };
      }
      .${stdenv.hostPlatform.system} or (throw "xtool: ${stdenv.hostPlatform.system} is unsupported.");

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [
    pkgs.swift
    pkgs.usbmuxd
  ];

  meta = {
    description = "Cross-platform Xcode replacement";
    homepage = "https://xtool.sh";
    changelog = "https://github.com/xtool-org/xtool/releases";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "xtool";
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
