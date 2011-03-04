{ stdenv, fetchurl, python }:

stdenv.mkDerivation rec {
  name = "sip-4.11.2";
  
  src = fetchurl {
    url = "http://nixos.org/tarballs/${name}.tar.gz";
    sha256 = "0g1pj203m491rhy111ayr4k4lsbcqd8sa1np503xv94a90b05l6f";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
