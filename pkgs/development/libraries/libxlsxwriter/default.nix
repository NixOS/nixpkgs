{ lib
, stdenv
, fetchFromGitHub
, minizip
, python3
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libxlsxwriter";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "libxlsxwriter";
    rev = "RELEASE_${version}";
    sha256 = "sha256-6MMQr0ynMmfZj+RFoKtLB/f1nTBfn9tcYpzyUwnfB3M=";
  };

  nativeBuildInputs = [
    python3.pkgs.pytest
  ];

  buildInputs = [
    minizip
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "USE_SYSTEM_MINIZIP=1"
  ];

  doCheck = true;

  checkTarget = "test";

  meta = with lib; {
    description = "C library for creating Excel XLSX files";
    homepage = "https://libxlsxwriter.github.io/";
    changelog = "https://github.com/jmcnamara/libxlsxwriter/blob/${src.rev}/Changes.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [ dotlambda ];
    platforms = platforms.unix;
  };
}
