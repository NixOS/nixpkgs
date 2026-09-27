{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
}:

let
  version = "2.5.23";
  pname = "worldmonitor";
  cpu_name = stdenv.hostPlatform.parsed.cpu.name;
  throwSystem = throw "Unsupported system: ${cpu_name}";

  arch =
    {
      x86_64 = "amd64";
    }
    .${cpu_name} or cpu_name;

  hash =
    {
      amd64 = "sha256-QEuPgOX1D0m08upP544NLCv5jXLnrHcCRT1TJIHKNY0=";
      aarch64 = "sha256-ZISYarD8Kwgd9pulfbeId7gmL3YUDVtxAPlcecw19lQ=";
    }
    .${arch} or throwSystem;

  src = fetchurl {
    url = "https://github.com/koala73/worldmonitor/releases/download/v${version}/World.Monitor_${version}_${arch}.AppImage";
    hash = hash;
  };

in
appimageTools.wrapType2 {
  inherit pname version src;
  meta = {
    description = "Real-time global intelligence dashboard";
    mainProgram = "worldmonitor";
    homepage = "https://github.com/koala73/worldmonitor";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ skohtv ];
    platforms = lib.platforms.linux;
  };
}
