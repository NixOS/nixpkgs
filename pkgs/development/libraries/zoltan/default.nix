{ stdenv
, lib
, fetchFromGitHub
, cmake
}:

let
  fortranSupport = false;
in
stdenv.mkDerivation rec {
  pname = "Zoltan";
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
    # TODO: Package pympi separately?
  ];

  cmakeFlags = [
    "-DSEACASProj_ENABLE_Zoltan:BOOL=ON"
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DSEACASProj_ENABLE_Fortran:BOOL=${lib.boolToString fortranSupport}"
  ];

  meta = with lib; {
    description = "Toolkit for Load-balancing, Partitioning, Ordering and Coloring";
    homepage = "https://github.com/gsjaardema/seacas";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jtojnar ];
  };
}
