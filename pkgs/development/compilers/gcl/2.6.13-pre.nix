{ stdenv, fetchgit, mpfr, m4, binutils, emacs, zlib, which
, texinfo, libX11, xorgproto, libXi, gmp, readline, strace
, libXext, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  name = "gcl-${version}";
  version = "2.6.13pre50";

  src = fetchgit {
    sha256 = "0vpxb6z5g9fjavrgx8gz8fsjvskfz64f63qibh5s00fvvndlwi88";
    url = "https://git.savannah.gnu.org/r/gcl.git";
    rev = "refs/tags/Version_2_6_13pre50";
  };

  postPatch = ''
    sed -e 's/<= obj-date/<= (if (= 0 obj-date) 1 obj-date)/' -i lsp/make.lisp
  ''
  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=902475
  + ''
    substituteInPlace h/elf64_i386_reloc.h \
      --replace 'case R_X86_64_PC32:' 'case R_X86_64_PC32: case R_X86_64_PLT32:'
  '';

  sourceRoot = "gcl/gcl";

  patches = [];

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xorgproto libXi
    libXext libXt libXaw libXmu
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
