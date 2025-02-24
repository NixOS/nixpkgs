{
  appimageTools,
  fetchurl,
  lib,
}:

let
  pname = "video2x";
  version = "6.4.0";

  src = fetchurl {
    url = "https://github.com/k4yt3x/video2x/releases/download/${version}/Video2X-x86_64.AppImage";
    hash = "sha256-gjj8ODJRB/CgihQNBpuu49uAxax0cLClFsxoMYP1+S0=";
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  meta = with lib; {
    description = "AI-powered video upscaling tool";
    homepage = "https://github.com/k4yt3x/video2x";
    license = licenses.agpl3Plus;
    platforms = platforms.linux;
    mainProgram = "video2x";
  };
}
