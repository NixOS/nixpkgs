{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "nasm-${version}";
  version = "2.14.01";

  src = fetchurl {
    url = "https://www.nasm.us/pub/nasm/releasebuilds/${version}/${name}.tar.bz2";
    sha256 = "1v9fazd3in0rphnw5ck58wqnl8dis4dyqpsqgjsm4h9jjj0vylvz";
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
