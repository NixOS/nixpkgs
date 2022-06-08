{ stdenv
, lib
, fetchFromGitHub
, cmake
, netcdf
, exodusII
, zoltan
}:

let
  fortranSupport = false;
in
stdenv.mkDerivation rec {
  pname = "ioss";
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
    exodusII
    zoltan
  ];

  cmakeFlags = [
    "-DSEACASProj_ENABLE_SEACASIoss:BOOL=ON"
    "-DSEACASProj_ENABLE_SEACASExodus:BOOL=OFF"
    "-DSEACASProj_ENABLE_Zoltan:BOOL=OFF"
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DSEACASProj_ENABLE_Fortran:BOOL=${lib.boolToString fortranSupport}"
  ];

  meta = with lib; {
    description = "Sierra IO System";
    homepage = "https://github.com/gsjaardema/seacas";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
