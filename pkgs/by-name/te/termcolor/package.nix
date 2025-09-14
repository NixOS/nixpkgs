{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "termcolor";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "ikalnytskyi";
    repo = "termcolor";
    rev = "v${version}";
    sha256 = "sha256-2RXQ8sn2VNhQ2WZfwCCeQuM6x6C+sLA6ulAaFtaDMZw=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DTERMCOLOR_TESTS=ON" ];
  CXXFLAGS = [
    # GCC 13: error: 'uint8_t' has not been declared
    "-include cstdint"
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ./test_termcolor
    runHook postCheck
  '';

  meta = {
    description = "Header-only C++ library for printing colored messages";
    homepage = "https://github.com/ikalnytskyi/termcolor";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
