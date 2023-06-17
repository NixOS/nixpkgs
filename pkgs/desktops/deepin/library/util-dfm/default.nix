{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, libmediainfo
, libsecret
, libisoburn
, libuuid
, udisks
}:

stdenv.mkDerivation rec {
  pname = "util-dfm";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-Mc3x0nTnEyMnruZotiT1J4BGOeNAQlCXGbO0yVJtqYM=";
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
    description = "A Toolkits of libdfm-io,libdfm-mount and libdfm-burn";
    homepage = "https://github.com/linuxdeepin/util-dfm";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
