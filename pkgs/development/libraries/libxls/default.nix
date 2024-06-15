{ lib, stdenv, fetchFromGitHub, fetchpatch, autoreconfHook, autoconf-archive }:

stdenv.mkDerivation rec {
  pname = "libxls";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "libxls";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vjmYByk+IDBon8xGR1+oNaEQTiJK+IVpDXsG1IyVNoY=";
  };

  patches = [
    # Fix cross-compilation
    (fetchpatch {
      url = "https://github.com/libxls/libxls/commit/007e63c1f5e19bc73292f267c85d7dd14e9ecb38.patch";
      sha256 = "sha256-PjPHuXth4Yaq9nVfk5MYJMRo5B0R6YA1KEqgwfjF3PM=";
    })
  ];

  nativeBuildInputs = [ autoreconfHook autoconf-archive ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Extract Cell Data From Excel xls files";
    homepage = "https://github.com/libxls/libxls";
    license = licenses.bsd2;
    maintainers = with maintainers; [ abbradar ];
    mainProgram = "xls2csv";
    platforms = platforms.unix;
    knownVulnerabilities = [
      "CVE-2023-38851"
      "CVE-2023-38852"
      "CVE-2023-38853"
      "CVE-2023-38854"
      "CVE-2023-38855"
      "CVE-2023-38856"
    ];
  };
}
