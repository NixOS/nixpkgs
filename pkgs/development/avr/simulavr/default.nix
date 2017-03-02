{ stdenv, fetchurl, python, doxygen, tcl, tk, binutils }:

stdenv.mkDerivation rec {
  name = "simulavr";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/simulavr/simulavr-1.0.0.tar.gz";
    sha256 = "39d93faa3eeae2bee15f682dd6a48fb4d4366addd12a2abebb04c99f87809be7";
  };

  configureFlags = [
    "--enable-python"
    "--enable-doxygen-doc"
    "--enable-tcl"
    "--with-bfd=${binutils}/lib/libbfd.la"
  ];
  
  buildInputs = [ python doxygen tcl tk binutils];

  meta = {
    description = "";
    homepage    = http://www.nongnu.org/simulavr/;
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.all;
  };
}
