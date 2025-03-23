{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "texturepacker";
  version = "7.6.0";

  src = fetchurl {
    url = "https://www.codeandweb.com/download/texturepacker/${finalAttrs.version}/TexturePacker-${finalAttrs.version}.deb";
    hash = "sha256-7xEIXgrMAV/MUGd+STjRtUAftVF2jj2OuH7SnSMpXk0=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ];

  installPhase = ''
    mkdir -p $out/bin $out/lib
    cp usr/lib/texturepacker/{libGrantlee_Templates.so.5,libHQX.so.1.0.0,libPVRTexLib.so} $out/lib
    cp usr/lib/texturepacker/TexturePacker $out/bin
    cp -r usr/share $out
  '';

  meta = {
    changelog = "https://www.codeandweb.com/texturepacker/download";
    description = "Sprite sheet creator and game graphics optimizer";
    homepage = "https://www.codeandweb.com/texturepacker";
    license = lib.licenses.unfree;
    mainProgram = "TexturePacker";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" ];
  };
})
