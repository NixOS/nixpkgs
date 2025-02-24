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

  meta = {
    description = "AI-powered video upscaling tool";
    changelog = "https://github.com/k4yt3x/video2x/releases/tag/${version}/CHANGELOG.md";
    homepage = "https://github.com/k4yt3x/video2x";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "video2x";
  };
}
