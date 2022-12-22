{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "nasm";
  version = "2.16";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${pname}-${version}.tar.xz";
    sha256 = "sha256-8F4twEvbB1SHIH13V3Dp5QjiUOY9qL9sdpl21m3VUkk=";
  };

  nativeBuildInputs = [ perl ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    make golden
    make test
  '';

  meta = with lib; {
    homepage = "https://www.nasm.us/";
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
    license = licenses.bsd2;
  };
}
