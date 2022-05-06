{ stdenv
, lib
, fetchFromGitHub
, cmake
, netcdf
, hdf5
}:

let
  fortranSupport = false;
in
stdenv.mkDerivation rec {
  pname = "exodus";
  version = "2022-01-27";

  src = fetchFromGitHub {
    owner = "gsjaardema";
    repo = "seacas";
    rev = "v${version}";
    sha256 = "mHTRUK+48icF9EzUUO6TPZEHqq/gAhKmqqXOXQ4s6Jo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    netcdf
    hdf5
  ];

  cmakeFlags = [
    "-DSEACASProj_ENABLE_SEACASExodus:BOOL=ON"
    "-DSEACASExodus_ENABLE_STATIC:BOOL=OFF"
    "-DSEACASProj_ENABLE_SEACASExodus_for:BOOL=${lib.boolToString fortranSupport}"
    "-DSEACASProj_ENABLE_SEACASExoIIv2for32:BOOL=${lib.boolToString fortranSupport}"
    "-DSEACASProj_ENABLE_Fortran:BOOL=${lib.boolToString fortranSupport}"
  ];

  meta = with lib; {
    description = "Finite Element Data Model";
    homepage = "https://github.com/gsjaardema/seacas";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
