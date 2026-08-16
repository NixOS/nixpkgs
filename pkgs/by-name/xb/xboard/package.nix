{
  lib,
  stdenv,
  fetchgit,
  libx11,
  xorgproto,
  libxt,
  libxaw,
  libsm,
  libice,
  libxmu,
  libxext,
  gnuchess,
  texinfo,
  libxpm,
  pkg-config,
  librsvg,
  cairo,
  pango,
  gtk3,
  autoreconfHook,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xboard";
  version = "4.9.1-unstable-2026-08-03";

  src = fetchgit {
    url = "https://https.git.savannah.gnu.org/git/xboard.git";
    rev = "46b3c1d4ea45529cb2054516ff50feb902628d1c";
    sha256 = "sha256-P21e6ikimEvm0k98RCeEuvC/ZVtWbosXzioOB18tUbI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    perl
  ];
  buildInputs = [
    libx11
    xorgproto
    libxt
    libxaw
    libsm
    libice
    libxmu
    libxext
    gnuchess
    texinfo
    libxpm
    librsvg
    cairo
    pango
    gtk3
  ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = {
    description = "GUI for chess engines";
    mainProgram = "xboard";
    homepage = "https://www.gnu.org/software/xboard/";
    maintainers = with lib.maintainers; [ raskin ];
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3Plus;
  };
})
