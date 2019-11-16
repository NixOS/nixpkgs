{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "rasm";
  version = "0.117";

  src = fetchurl {
    url = "www.roudoudou.com/export/cpc/rasm/${pname}_v0117_src.zip";
    sha256 = "1hwily4cfays59qm7qd1ax48i7cpbxhs5l9mfpyn7m2lxsfqrl3z";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
      # according to official documentation
      cc rasm_v*.c -O2 -lm -lrt -march=native -o rasm
  '';

  installPhase = ''
    install -Dt $out/bin rasm
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.roudoudou.com/rasm/";
    description = "Z80 assembler";
    # use -n option to display all licenses
    license = licenses.mit; # expat version
    maintainers = [ maintainers.genesis ];
    platforms = platforms.linux;
  };
}
