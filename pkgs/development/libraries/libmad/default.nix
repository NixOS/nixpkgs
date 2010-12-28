{stdenv, fetchurl, autoconf}:

stdenv.mkDerivation {
  name = "libmad-0.15.1b";
  
  src = fetchurl {
    url = mirror://sourceforge/mad/libmad-0.15.1b.tar.gz;
    sha256 = "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690";
  };

  patches = [ ./001-mips_removal_h_constraint.patch ./pkgconfig.patch ];

  buildNativeInputs = [ autoconf ];

  # The -fforce-mem flag has been removed in GCC 4.3.
  preConfigure = ''
    autoconf
    substituteInPlace configure --replace "-fforce-mem" ""
  '';

  meta = {
    homepage = http://sourceforge.net/projects/mad/;
    description = "A high-quality, fixed-point MPEG audio decoder supporting MPEG-1 and MPEG-2";
  };
}
