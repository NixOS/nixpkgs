{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  qt6Packages,

  lzo,
  openldap,
  cyrus_sasl,
  pam,
  procps,
  libXtst,
  libXrandr,
  libXinerama,
  libXdamage,
  libXcursor,
  libvncserver,
  libfakekey,
  pipewire,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "veyon";
  version = "4.11.3";

  src = fetchFromGitHub {
    owner = "veyon";
    repo = "veyon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k2/QOehw1wvt5auoyDV5TsiXaMZDOcCB7oDUrBUNM6M=";
    fetchSubmodules = true; # kldap, x11vnc and qthttpserver get built from source
  };

  patches = [
    # we are not allowed to set suid during the build
    # the NixOS module provides veyon-auth-helper and veyon-input-helper with suid as a security wrapper
    ./install-disable-setuid.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qt5compat
    qt6Packages.qttools
    qt6Packages.qthttpserver
    qt6Packages.qca

    lzo
    openldap
    cyrus_sasl
    pam
    procps
    libXtst
    libXrandr
    libXinerama
    libXdamage
    libXcursor
    libvncserver
    libfakekey
    pipewire
  ];

  cmakeFlags = [
    # cmake's setup hook makes it so that this is absolute by default
    # veyon's build steps only work if this is relative
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeFeature "SYSTEMD_SERVICE_INSTALL_DIR" "lib/systemd/system")
  ];

  meta = {
    changelog = "https://github.com/veyon/veyon/releases/tag/v${finalAttrs.version}";
    description = "Cross-platform computer monitoring and classroom management software";
    homepage = "https://veyon.io";
    license = lib.licenses.gpl2Only;
    mainProgram = "veyon-master";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
