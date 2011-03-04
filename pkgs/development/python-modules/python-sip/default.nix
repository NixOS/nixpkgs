{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.12.1";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "1dc16f8m52qc824ksvyfhkdmsjbxyq82g5dr2xn8x9f26246xmp9";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
