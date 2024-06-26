{ lib
, stdenv
, fetchFromGitHub
, cmake
, parallelSupport ? (!stdenv.isDarwin)
}:

let
  mkFlag = optset: flag: if optset then "-D${flag}=ON" else "-D${flag}=OFF";
in

stdenv.mkDerivation rec {
  pname = "stxxl";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "stxxl";
    repo = "stxxl";
    rev = version;
    sha256 = "sha256-U6DQ5mI83pyTmq5/ga5rI8v0h2/iEnNl8mxhIOpbF1I=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_STATIC_LIBS=OFF"
    (mkFlag parallelSupport "USE_GNU_PARALLEL")
    (mkFlag parallelSupport "USE_OPENMP")
  ];

  passthru = {
    inherit parallelSupport;
  };

  meta = with lib; {
    description = "Implementation of the C++ standard template library STL for external memory (out-of-core) computations";
    homepage = "https://github.com/stxxl/stxxl";
    license = licenses.boost;
    maintainers = with maintainers; [ ];
    mainProgram = "stxxl_tool";
    platforms = platforms.all;
  };
}
