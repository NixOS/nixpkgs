{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.10.5";
  
  src = fetchurl {
    url = "http://www.riverbankcomputing.co.uk/static/Downloads/sip4/${name}.tar.gz";
    sha256 = "1hkn2n5hvfcfz0xprwyy5dzjzndgmvlf7abjsd868pv3hxdx1rs8";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
