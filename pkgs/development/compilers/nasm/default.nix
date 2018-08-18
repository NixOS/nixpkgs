{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.13.03";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "04bh736zfj3xy5ihh1whshpjxsisv7hqkz954clzdw6kg93qdv33";
  };

  nativeBuildInputs = [ perl ];

  doCheck = true;

  checkPhase = ''
    make golden && make test
  '';

  meta = with stdenv.lib; {
    homepage = https://www.nasm.us/;
    description = "An 80x86 and x86-64 assembler designed for portability and modularity";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub willibutz ];
    license = licenses.bsd2;
  };
}
