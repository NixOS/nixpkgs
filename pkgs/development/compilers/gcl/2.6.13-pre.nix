{ stdenv, fetchFromSavannah, mpfr, m4, binutils, fetchcvs, emacs, zlib, which
, texinfo, libX11, xproto, inputproto, libXi, gmp, readline, strace
, libXext, xextproto, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  name = "gcl-${version}";
  version = "2.6.13pre50";

  src = fetchFromSavannah {
    sha256 = "199cca3j7nxs1qvlf5k1acz6hgqnd31zv81yy18m4pmd7fh2ng50";
    repo = "gcl";
    rev = "refs/tags/Version_2_6_13pre50";
  };

  postPatch = ''
    sed -e 's/<= obj-date/<= (if (= 0 obj-date) 1 obj-date)/' -i lsp/make.lisp
  '';

  sourceRoot = "gcl/gcl";

  patches = [];

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xproto inputproto libXi
    libXext xextproto libXt libXaw libXmu
    zlib which texinfo readline strace
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  hardeningDisable = [ "pic" "bindnow" ];

  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
