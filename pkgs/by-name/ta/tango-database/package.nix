{
  stdenv,
  lib,
  cmake,
  cppzmq,
  fetchFromGitLab,
  grpc,
  libjpeg,
  mariadb,
  mariadb-connector-c,
  omniorb,
  opentelemetry-cpp,
  protobuf,
  tango-cpp,
}:

# NOTE: You need to manually set up the database structure to run Tango successfully.
# See $out/share/tango/db/create_db.sh
stdenv.mkDerivation rec {
  pname = "tango-database";
  version = "5.24";
  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoDatabase";
    rev = "Database-Release-${version}";
    fetchSubmodules = true;
    hash = "sha256-Gxwr45HKiij1spaGvgK+vFwtiBJADqqmHCdFpjaRU7I=";
  };

  nativeBuildInputs = [
    cmake
    cppzmq
    mariadb-connector-c.dev
  ];

  buildInputs = [
    grpc
    libjpeg
    mariadb.client
    mariadb-connector-c
    omniorb
    opentelemetry-cpp
    protobuf
    tango-cpp
  ];

  # their FindMySQL.cmake fails to find these libraries,
  # maybe because mariadb-connector-c puts its libraries into $out/lib/mariadb, not $out/lib ?
  cmakeFlags = [
    "-DMySQL_INCLUDE_DIR=${mariadb-connector-c.dev}/include/mysql"
    "-DMySQL_LIBRARY_DEBUG=${mariadb-connector-c}/lib/mariadb/libmariadb.so"
    "-DMySQL_LIBRARY_RELEASE=${mariadb-connector-c}/lib/mariadb/libmariadb.so"
  ];

  postFixup = ''
    patchelf --add-rpath ${mariadb-connector-c}/lib/mariadb $out/bin/Databaseds
  '';

  meta = {
    description = "Tango distributed control system - database server";
    homepage = "https://gitlab.com/tango-controls/TangoDatabase";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gilice ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
