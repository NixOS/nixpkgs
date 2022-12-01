{ lib
, stdenv
, fetchFromGitHub
, cmake
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

  doCheck = true;

  checkPhase = ''
    runHook preCheck
    ./test_termcolor
    runHook postCheck
  '';

  meta = with lib; {
    description = "Header-only C++ library for printing colored messages";
    homepage = "https://github.com/ikalnytskyi/termcolor";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ prusnak ];
  };
}
