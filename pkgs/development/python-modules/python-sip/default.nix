{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.12.4";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "1cs7q2z5r59yil71ysy9nc32x0s65b9dz9jcrdsjmp6cww51z33n";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
