{
  fetchzip,
  lib,
}:
let
  /*
    see:
    https://github.com/Mastermindzh/tidal-hifi/blob/master/build/electron-builder.base.yml
     for the expected version
  */
  version = "35.1.1";
in
(fetchzip {
  url = "https://github.com/castlabs/electron-releases/releases/download/v${version}+wvcus/electron-v${version}+wvcus-linux-x64.zip";
  hash = "sha256-AkPKeG7MrCBlk41qXZxFPRukUPRcIUanq6fJPx5d3RU=";
  stripRoot = false;

}).overrideAttrs
  (
    final: _: {
      name = "castlabs-electron-${version}";
      inherit version;
      pname = "castlabs-electron";
      passthru.dist = final.finalPackage.outPath;

      meta = {
        license = lib.licenses.unfreeRedistributable;
        sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      };
    }
  )
