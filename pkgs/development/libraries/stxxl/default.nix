{ lib
, stdenv
, fetchFromGitHub
, cmake
, parallel ? true
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
    (mkFlag parallel "USE_GNU_PARALLEL")
  ];

  passthru = {
    inherit parallel;
  };

  meta = with lib; {
    description = "An implementation of the C++ standard template library STL for external memory (out-of-core) computations";
    homepage = "https://github.com/stxxl/stxxl";
    license = licenses.boost;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
