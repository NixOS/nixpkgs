{ lib, stdenv, fetchgit, mpfr, m4, binutils, emacs, zlib, which
, texinfo, libX11, xorgproto, libXi, gmp, readline
, libXext, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  pname = "gcl";
  version = "2.6.13pre124";

  src = fetchgit {
    sha256 = "sha256-e4cUQlNSfdz+B3urlZ82pf7fTc6aoloUyDDorAUi5kc=";
    url = "https://git.savannah.gnu.org/r/gcl.git";
    rev = "refs/tags/Version_${builtins.replaceStrings ["."] ["_"] version}";
  };

  postPatch = ''
    sed -e 's/<= obj-date/<= (if (= 0 obj-date) 1 obj-date)/' -i lsp/make.lisp
  '';

  sourceRoot = "gcl/gcl";

  # breaks when compiling in parallel
  enableParallelBuilding = false;

  patches = [];

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xorgproto libXi
    libXext libXt libXaw libXmu
    zlib which texinfo readline
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  hardeningDisable = [ "pic" "bindnow" ];

  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
  };
}
