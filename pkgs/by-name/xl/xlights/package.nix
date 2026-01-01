{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "xlights";
<<<<<<< HEAD
  version = "2025.13";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-HYOfcANhOmngNxtMYT53N2aoAI/0n/n+WMyQfjkuqXg=";
=======
  version = "2025.12";

  src = fetchurl {
    url = "https://github.com/smeighan/xLights/releases/download/${version}/xLights-${version}-x86_64.AppImage";
    hash = "sha256-INB4x2iCzjpURL7VhugCcYo+X6p6aKIY5Dx5dy1ZjJ8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    description = "Sequencer for lights with USB and E1.31 drivers";
    homepage = "https://xlights.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ kashw2 ];
    platforms = lib.platforms.linux;
    mainProgram = "xlights";
  };
}
