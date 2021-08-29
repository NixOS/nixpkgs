{ lib, stdenv, fetchFromGitHub, pkg-config, sqlite, autoreconfHook, libtiff, curl }:

stdenv.mkDerivation rec {
  pname = "proj";
  version = "7.2.1";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "PROJ";
    rev = version;
    sha256 = "0mymvfvs8xggl4axvlj7kc1ksd9g94kaz6w1vdv0x2y5mqk93gx9";
  };

  outputs = [ "out" "dev"];

  nativeBuildInputs = [ pkg-config autoreconfHook ];

  buildInputs = [ sqlite libtiff curl ];

  doCheck = stdenv.is64bit;

  meta = with lib; {
    description = "Cartographic Projections Library";
    homepage = "https://proj4.org";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ vbgl ];
  };
}
