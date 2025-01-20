{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  patches = [
    (fetchpatch {
      url = "https://github.com/arximboldi/zug/commit/c8c74ada30d931e40636c13763b892f20d3ce1ae.patch";
      hash = "sha256-0x+ScRnziBeyHWYJowcVb2zahkcK2qKrMVVk2twhtHA=";
    })
  ];
  nativeBuildInputs = [
    cmake
  ];
  buildInputs = [
    boost
  ];
  cmakeFlags = [
    "-Dzug_BUILD_EXAMPLES=OFF"
  ];
  preConfigure = ''
    rm BUILD
  '';
  meta = with lib; {
    homepage = "https://github.com/arximboldi/zug";
    description = "library for functional interactive c++ programs";
    maintainers = with maintainers; [ nek0 ];
    license = licenses.boost;
  };
}
