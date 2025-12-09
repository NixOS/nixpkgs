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
stdenv.mkDerivation rec {
  pname = "tango-database";
  version = "5.25";

  src = fetchFromGitLab {
    owner = "tango-controls";
    repo = "TangoDatabase";
    tag = "Database-Release-${version}";
    fetchSubmodules = true;
    hash = "sha256-hu2TIPxXyUtLK3bHFHuBYho23TGLkmsHfxEabsjsvmE=";
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
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.gilice ];
  };
}
