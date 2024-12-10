{
  lib,
  stdenv,
  fetchFromGitHub,
  minizip,
  python3,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libxlsxwriter";
  version = "1.1.7";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "libxlsxwriter";
    rev = "RELEASE_${version}";
    hash = "sha256-bJ0NMbK9c21YYdcg/TW3ePSDVi5hly6lSW7wXFskI8M=";
  };

  buildInputs = [
    minizip
    zlib
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "USE_SYSTEM_MINIZIP=1"
  ];

  # TEST 428/429 worksheet:worksheet_table15 *** buffer overflow detected ***: terminated
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  nativeCheckInputs = [
    python3.pkgs.pytest
  ];

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
