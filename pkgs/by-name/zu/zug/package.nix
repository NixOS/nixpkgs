{ callPackage, stdenv, lib, pkgs,
  fetchFromGitHub,
  cmake, boost
}:


stdenv.mkDerivation rec {
  pname = "zug";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7xTMDhPIx1I1PiYNanGUsK8pdrWuemMWM7BW+NQs2BQ=";
  };
  buildInputs = [
    cmake
    boost
  ];
  cmakeFlags = [
    "-Dzug_BUILD_TESTS=OFF"
    "-Dzug_BUILD_EXAMPLES=OFF"
  ];
  meta = with lib; {
    homepage    = "https://github.com/arximboldi/zug";
    description = "library for functional interactive c++ programs";
    maintainers = with maintainers; [ nek0 ];
    license     = licenses.boost;
  };
}
