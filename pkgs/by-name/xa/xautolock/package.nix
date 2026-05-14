{
  lib,
  stdenv,
  fetchFromGitHub,
  imake,
  gccmakedep,
  libx11,
  libxext,
  libxscrnsaver,
  xorgproto,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xautolock";
  version = "2.2-7-ga23dd5c";

  # This repository contains xautolock-2.2 plus various useful patches that
  # were collected from Debian, etc.
  src = fetchFromGitHub {
    owner = "peti";
    repo = "xautolock";
    rev = "v${finalAttrs.version}";
    hash = "sha256-T2zAbRqSTxRp9u6EdZmIZfVxaGveeZkJgjp1DWgORoI=";
  };

  nativeBuildInputs = [
    imake
    gccmakedep
  ];
  buildInputs = [
    libx11
    libxext
    libxscrnsaver
    xorgproto
  ];

  makeFlags = [
    "BINDIR=$(out)/bin"
    "MANPATH=$(out)/share/man"
  ];

  installTargets = [
    "install"
    "install.man"
  ];

  passthru.tests = { inherit (nixosTests) xautolock; };

  meta = {
    description = "Launch a given program when your X session has been idle for a given time";
    homepage = "http://www.ibiblio.org/pub/linux/X11/screensavers";
    maintainers = with lib.maintainers; [ peti ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    mainProgram = "xautolock";
  };
})
