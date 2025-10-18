{
  mkDerivation,
  lib,
  fetchurl,
  fetchpatch,
  extra-cmake-modules,
  qtbase,
  kcoreaddons,
  python3,
  sqlite,
  libpq,
  libmysqlclient,
  qttools,
}:

mkDerivation rec {
  pname = "kdb";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/kdb/src/kdb-${version}.tar.xz";
    sha256 = "0s909x34a56n3xwhqz27irl2gbzidax0685w2kf34f0liny872cg";
  };

  patches = [
    # fix build with newer QT versions
    (fetchpatch {
      url = "https://github.com/KDE/kdb/commit/b36d74f13a1421437a725fb74502c993c359392a.patch";
      hash = "sha256-ENMZTUZ3yCKUhHPMUcDe1cMY2GLBz0G3ZvMRyj8Hfrw=";
    })
    # fix build with newer posgresql versions
    (fetchpatch {
      url = "https://github.com/KDE/kdb/commit/40cdaea4d7824cc1b0d26e6ad2dcb61fa2077911.patch";
      hash = "sha256-cZpX6L/NZX3vztnh0s2+v4J7kBcKgUdecY53LRp8CwM=";
    })
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    qttools
  ];

  buildInputs = [
    kcoreaddons
    python3
    sqlite
    libpq
    libmysqlclient
  ];

  propagatedBuildInputs = [ qtbase ];

  meta = with lib; {
    description = "Database connectivity and creation framework for various database vendors";
    mainProgram = "kdb3_sqlite3_dump";
    license = licenses.lgpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zraexy ];
  };
}
