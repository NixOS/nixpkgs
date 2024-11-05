{
  lib,
  stdenv,
  fetchurl,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yudit";
  version = "3.1.0";

  src = fetchurl {
    url = "https://www.yudit.org/download/yudit-${finalAttrs.version}.tar.gz";
    hash = "sha256-oYgjTWEnNXaE9Sw9bGpLnY9avQ99tnJWa/RE73p85Vc=";
  };

  buildInputs = [
    xorg.libX11
  ];

  meta = {
    description = "Free Unicode plain-text editor for Unix-like systems";
    homepage = "https://www.yudit.org/";
    changelog = "https://www.yudit.org/download/CHANGELOG.TXT";
    mainProgram = "yudit";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    # Might work on Darwin but currently fails, and upstream doesn't officially
    # supports it.
    platforms = lib.platforms.linux;
  };
})
