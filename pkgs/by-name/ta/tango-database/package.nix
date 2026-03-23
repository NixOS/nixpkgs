{
  stdenv,
  lib,
  cmake,
  cppzmq,
  fetchFromGitLab,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "tango-database";
  version = "5.28";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoDatabase";
    tag = "Database-Release-${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-r8jrsDR22u30l1R6mK95KsLWHhheZa4/N6n/Xv4mKPc=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cppzmq
    libjpeg
    mariadb.client
    mariadb-connector-c.dev
    omniorb
    (opentelemetry-cpp.override {
      enableGrpc = true;
      enableHttp = true;
    })
    protobuf
    tango-cpp
  ];

  # their FindMySQL.cmake fails to find these libraries,
  # maybe because mariadb-connector-c puts its libraries into $out/lib/mariadb, not $out/lib?
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
    changelog = "https://gitlab.com/tango-controls/TangoDatabase/-/blob/Database-Release-${finalAttrs.version}/RELEASE_NOTES.md";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gilice ];
  };
})
