{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, minizip
, python3
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libxlsxwriter";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "jmcnamara";
    repo = "libxlsxwriter";
    rev = "RELEASE_${version}";
    sha256 = "sha256-Ef1CipwUEJW/VYx/q98lN0PSxj8c3DbIuql8qU6mTRs=";
  };

  patches = [
    # https://github.com/jmcnamara/libxlsxwriter/pull/357
    (fetchpatch {
      url = "https://github.com/jmcnamara/libxlsxwriter/commit/723629976ede5e6ec9b03ef970381fed06ef95f0.patch";
      sha256 = "14aw698b5svvbhvadc2vr71isck3k02zdv8xjsa7c33n8331h20g";
    })
  ];

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
