{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qtbase,
  libmediainfo,
  libsecret,
  libisoburn,
  libuuid,
  udisks,
}:

stdenv.mkDerivation rec {
  pname = "util-dfm";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-ngDjjdwuYqvyhaUcMNV5PRmGKC3lmY/nJQGOQgRMIQE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  dontWrapQtApps = true;

  buildInputs = [
    qtbase
    libmediainfo
    libsecret
    libuuid
    libisoburn
    udisks
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DPROJECT_VERSION=${version}"
  ];

  meta = with lib; {
    description = "Toolkits of libdfm-io,libdfm-mount and libdfm-burn";
    homepage = "https://github.com/linuxdeepin/util-dfm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
