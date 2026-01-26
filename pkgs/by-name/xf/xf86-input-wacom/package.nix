{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  xorgproto,
  libX11,
  libXext,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  ncurses,
  pixman,
  pkg-config,
  udev,
  udevCheckHook,
  utilmacros,
  xorgserver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-wacom";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "xf86-input-wacom";
    rev = "xf86-input-wacom-${finalAttrs.version}";
    sha256 = "sha256-12m9PL28NnqIwNpGHOFqjJaNrzBaagdG3Sp/jSLpgkE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    udevCheckHook
  ];

  buildInputs = [
    libX11
    libXext
    libXi
    libXinerama
    libXrandr
    libXrender
    ncurses
    udev
    utilmacros
    pixman
    xorgproto
    xorgserver
  ];

  doInstallCheck = true;

  configureFlags = [
    "--with-xorg-module-dir=${placeholder "out"}/lib/xorg/modules"
    "--with-sdkdir=${placeholder "out"}/include/xorg"
    "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
  ];

  meta = {
    maintainers = with lib.maintainers; [ moni ];
    description = "Wacom digitizer driver for X11";
    homepage = "https://linuxwacom.sourceforge.net";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux; # Probably, works with other unixes as well
  };
})
