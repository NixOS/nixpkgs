{stdenv, fetchurl, autoconf}:

stdenv.mkDerivation rec {
  name = "libmad-0.15.1b";
  
  src = fetchurl {
    url = "mirror://sourceforge/mad/${name}.tar.gz";
    sha256 = "bbfac3ed6bfbc2823d3775ebb931087371e142bb0e9bb1bee51a76a6e0078690";
  };

  patches = [ ./001-mips_removal_h_constraint.patch ./pkgconfig.patch ]
  # optimize.diff is taken from https://projects.archlinux.org/svntogit/packages.git/tree/trunk/optimize.diff?h=packages/libmad
  # It is included here in order to fix a build failure in Clang
  # But it may be useful to fix other, currently unknown problems as well
  ++ stdenv.lib.optional stdenv.cc.isClang [ ./optimize.diff ];

  nativeBuildInputs = [ autoconf ];

  # The -fforce-mem flag has been removed in GCC 4.3.
  preConfigure = ''
    autoconf
    substituteInPlace configure --replace "-fforce-mem" ""
    substituteInPlace configure --replace "arch=\"-march=i486\"" ""
  '';

  meta = with stdenv.lib; {
    homepage    = https://sourceforge.net/projects/mad/;
    description = "A high-quality, fixed-point MPEG audio decoder supporting MPEG-1 and MPEG-2";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
