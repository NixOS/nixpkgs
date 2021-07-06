{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, sqlite
, libtiff
, curl
, gtest
}:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "sha256-pgmv/mtqpKbgU1RuKtue7NAnMyXR1BwGJwoeA/MTrpY=";
  };

  postPatch = lib.optionalString (version == "7.2.1") ''
    substituteInPlace CMakeLists.txt \
      --replace "MAJOR 7 MINOR 2 PATCH 0" "MAJOR 7 MINOR 2 PATCH 1"
  '';

  outputs = [ "out" "dev"];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ sqlite libtiff curl ];

  checkInputs = [ gtest ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_GTEST=ON"
  ];

  doCheck = stdenv.is64bit;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj4.org";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ vbgl dotlambda ];
  };
}
