{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  cmake,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "zug";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "zug";
    rev = "v${version}";
    hash = "sha256-7xTMDhPIx1I1PiYNanGUsK8pdrWuemMWM7BW+NQs2BQ=";
  };
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    boost
  ];
  cmakeFlags = [
    "-Dzug_BUILD_EXAMPLES=OFF"
  ];
  meta = with lib; {
    homepage = "https://github.com/arximboldi/zug";
    description = "library for functional interactive c++ programs";
    maintainers = with maintainers; [ nek0 ];
    license = licenses.boost;
  };
}
