{ stdenv, fetchurl, pkgconfig, guile, autoconf, flex, fetchpatch }:

stdenv.mkDerivation rec {
  version = "1.1.11";
  name = "libmatheval-${version}";

  nativeBuildInputs = [ pkgconfig autoconf flex ];
  buildInputs = [ guile ];

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/libmatheval/${name}.tar.gz";
    sha256 = "474852d6715ddc3b6969e28de5e1a5fbaff9e8ece6aebb9dc1cc63e9e88e89ab";
  };

  # Patches coming from debian package
  # https://packages.debian.org/source/sid/libs/libmatheval
  patches = [ (fetchpatch {
                url = "http://anonscm.debian.org/cgit/debian-science/packages/libmatheval.git/plain/debian/patches/002-skip-docs.patch";
                sha256 = "1nnkk9aw4jj6nql46zhwq6vx74zrmr1xq5ix0xyvpawhabhgjg62";
              } )
              (fetchpatch {
                url = "http://anonscm.debian.org/cgit/debian-science/packages/libmatheval.git/plain/debian/patches/003-guile2.0.patch";
                sha256 = "1xgfw4finfvr20kjbpr4yl2djxmyr4lmvfa11pxirfvhrdi602qj";
               } )
              (fetchpatch {
                url = "http://anonscm.debian.org/cgit/debian-science/packages/libmatheval.git/plain/debian/patches/disable_coth_test.patch";
                sha256 = "0bai8jrd5azfz5afmjixlvifk34liq58qb7p9kb45k6kc1fqqxzm";
               } )
            ];
  
  meta = {
    description = "A library to parse and evaluate symbolic expressions input as text";
    longDescription = ''
      GNU libmatheval is a library (callable from C and Fortran) to parse and evaluate symbolic 
      expressions input as text. It supports expressions in any number of variables of arbitrary 
      names, decimal and symbolic constants, basic unary and binary operators, and elementary 
      mathematical functions. In addition to parsing and evaluation, libmatheval can also compute 
      symbolic derivatives and output expressions to strings.
    '';
    homepage = https://www.gnu.org/software/libmatheval/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.bzizou ];
    platforms = stdenv.lib.platforms.linux;
  };
}

