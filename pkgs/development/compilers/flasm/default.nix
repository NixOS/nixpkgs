{ stdenv, fetchzip, unzip, bison, flex, gperf, zlib }:

stdenv.mkDerivation rec {
  pname = "flasm";
  version = "1.64";

  src = fetchzip {
    url = "https://www.nowrap.de/download/flasm16src.zip";
    sha256 = "03hvxm66rb6rjwbr07hc3k7ia5rim2xlhxbd9qmcai9xwmyiqafg";
    stripRoot = false;
  };

  makeFlags = [ "CC=cc" ];

  nativeBuildInputs = [ unzip bison flex gperf ];

  buildInputs = [ zlib ];

  installPhase = ''
    install -Dm755 flasm -t $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Assembler and disassembler for Flash (SWF) bytecode";
    homepage = "http://flasm.sourceforge.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.all;
  };
}
