{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.12.3";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "0zmpq10f58hl0zy26p5s8flsbp6g0dsq8hvi4mlmqp60lhichlml";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
