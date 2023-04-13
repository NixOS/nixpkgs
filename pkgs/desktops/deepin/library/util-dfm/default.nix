{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
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
  version = "1.2.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-+qqirRkvVyKvt+Pu/ghQjMe+O6a7/7IoJL8AWL4QlvE=";
  };

  patches = [
    (fetchpatch {
      name = "fix-use-pkgconfig-to-check-mount.patch";
      url = "https://github.com/linuxdeepin/util-dfm/commit/fb8425a8c13f16e86db38ff84f43347fdc8ea468.diff";
      sha256 = "sha256-PGSRfnQ1MGmq0V3NBCoMk4p/T2x19VA04u9C+WcBKow=";
    })
  ];

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
