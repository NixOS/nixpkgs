{
  lib,
  stdenv,
  autoreconfHook,
  fetchFromGitHub,
  xorgproto,
  libx11,
  libxext,
  libxi,
  libxinerama,
  libxrandr,
  libxrender,
  ncurses,
  pixman,
  pkg-config,
  udev,
  udevCheckHook,
  util-macros,
  xorg-server,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-input-wacom";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "linuxwacom";
    repo = "xf86-input-wacom";
    tag = "xf86-input-wacom-${finalAttrs.version}";
    hash = "sha256-12m9PL28NnqIwNpGHOFqjJaNrzBaagdG3Sp/jSLpgkE=";
  };

  preConfigure = ''
    # See VERFILE in git-version-gen
    echo ${finalAttrs.version} > version
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    udevCheckHook
    util-macros
  ];

  buildInputs = [
    libx11
    libxext
    libxi
    libxinerama
    libxrandr
    libxrender
    ncurses
    udev
    pixman
    xorgproto
    xorg-server
  ];

  doInstallCheck = true;

  configureFlags = [
    "--with-xorg-module-dir=${placeholder "out"}/lib/xorg/modules"
    "--with-sdkdir=${placeholder "out"}/include/xorg"
    "--with-xorg-conf-dir=${placeholder "out"}/share/X11/xorg.conf.d"
  ];

  strictDeps = true;

  meta = {
    maintainers = with lib.maintainers; [ moni ];
    description = "Wacom digitizer driver for X11";
    homepage = "https://linuxwacom.sourceforge.net";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux; # Probably, works with other unixes as well
  };
})
