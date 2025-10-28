{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # bump minimal required cmake version
    (fetchpatch {
      url = "https://github.com/ikalnytskyi/termcolor/commit/89f20096bef51de347ec6f99345f65147359bd7c.patch?full_index=1";
      hash = "sha256-xouiacA+Kpjz+KOw6PgNRCXHAMENiqMww2WTvAvUpCE=";
    })
  ];

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

  meta = with lib; {
    description = "Header-only C++ library for printing colored messages";
    homepage = "https://github.com/ikalnytskyi/termcolor";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ prusnak ];
  };
}
