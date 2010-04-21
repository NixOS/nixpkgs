{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.10.2";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "1vw810fa3g59r3cnfizxykq7dg84zcgs278cwrksk7rsgz8gdn9q";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
