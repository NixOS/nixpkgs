{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  imagemagick,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbview";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "gregkh";
    repo = "usbview";
    rev = "v${finalAttrs.version}";
    hash = "sha256-h+sB83BYsrB2VxwtatPWNiM0WdTCMY289nh+/0o8GOw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    imagemagick
  ];

  buildInputs = [
    gtk3
  ];

  meta = {
    description = "USB viewer for Linux";
    license = lib.licenses.gpl2Only;
    homepage = "http://www.kroah.com/linux-usb/";
    maintainers = with lib.maintainers; [
      h7x4
    ];
    platforms = lib.platforms.linux;
    mainProgram = "usbview";
  };
})
