{
  lib,
  stdenv,
  fetchurl,
  libsForQt5,
  pkg-config,
  bash,
  cups,
  libXpm,
  libssh,
  nx-libs,
  openldap,
  openssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x2goclient";
  version = "4.1.2.3";

  src = fetchurl {
    url = "https://code.x2go.org/releases/source/x2goclient/x2goclient-${finalAttrs.version}.tar.gz";
    hash = "sha256-q4uzx40xYlx0nkLxX4EP49JCknoVKYMIwT3qO5Fayjw=";
  };

  buildInputs = [
    cups
    libXpm
    libssh
    libsForQt5.phonon
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qttools
    libsForQt5.qtx11extras
    nx-libs
    openldap
    openssh
  ];

  nativeBuildInputs = [
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace src/onmainwindow.cpp \
      --replace-fail "/usr/sbin/sshd" "${lib.getExe' openssh "sshd"}"
    substituteInPlace Makefile \
      --replace-fail "SHELL=/bin/bash" "SHELL ?= ${lib.getExe bash}" \
      --replace-fail "lrelease-qt4" "${lib.getExe' libsForQt5.qttools.dev "lrelease"}" \
      --replace-fail "qmake-qt4" "${lib.getExe' libsForQt5.qtbase.dev "qmake"}" \
      --replace-fail "-o root -g root" ""
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc"
    "build_client"
    "build_man"
    # No rule to make target 'SHELL'
    "MAKEOVERRIDES="
    ".MAKEOVERRIDES="
    ".MAKEFLAGS="
  ];

  installTargets = [
    "install_client"
    "install_man"
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${nx-libs}/bin:${openssh}/libexec"
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = {
    description = "Graphical NoMachine NX3 remote desktop client";
    mainProgram = "x2goclient";
    homepage = "http://x2go.org/";
    maintainers = [ ];
    license = with lib.licenses; [
      agpl3Plus
      mit
      free
    ]; # Some X2Go components are licensed under some license (MIT X11, BSD, etc.)
    platforms = lib.platforms.linux;
  };
})
