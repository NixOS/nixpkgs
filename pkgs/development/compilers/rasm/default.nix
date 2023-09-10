{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "rasm";
  version = "0.117";

  src = fetchurl {
    url = "http://www.roudoudou.com/export/cpc/rasm/${pname}_v0117_src.zip";
    sha256 = "1hwily4cfays59qm7qd1ax48i7cpbxhs5l9mfpyn7m2lxsfqrl3z";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ unzip ];

  buildPhase = ''
      # according to official documentation
      ${stdenv.cc.targetPrefix}cc rasm_v*.c -O2 -lm -o rasm
  '';

  installPhase = ''
    install -Dt $out/bin rasm
  '';

  meta = with lib; {
    homepage = "http://www.roudoudou.com/rasm/";
    description = "Z80 assembler";
    # use -n option to display all licenses
    license = licenses.mit; # expat version
    maintainers = [ ];
    platforms = platforms.all;
  };
}
