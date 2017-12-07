{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.13.01";

  src = fetchurl {
    url = "http://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "1ylqs4sqh0paia970v6hpdgq5icxns9zlg21qql232bz1apppy88";
  };

  nativeBuildInputs = [ perl ];

  doCheck = true;

  checkPhase = ''
    make golden && make test
  '';

  meta = with stdenv.lib; {
    homepage = http://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
  };
}
