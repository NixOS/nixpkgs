{
  lib,
  stdenv,
  fetchurl,
  perl,
}:
stdenv.mkDerivation rec {
  pname = "xmlformat";
  version = "1.04";

  src = fetchurl {
    url = "http://www.kitebird.com/software/xmlformat/xmlformat-${version}.tar.gz";
    sha256 = "1vwgzn4ha0az7dx0cyc6dx5nywwrx9gxhyh08mvdcq27wjbh79vi";
  };

  buildInputs = [ perl ];
  buildPhase = ''
    patchShebangs ./xmlformat.pl
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./xmlformat.pl $out/bin/xmlformat
    cp ./LICENSE $out/
  '';

  meta = {
    description = "Configurable formatter (or 'pretty-printer') for XML documents";
    mainProgram = "xmlformat";
    homepage = "http://www.kitebird.com/software/xmlformat/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
