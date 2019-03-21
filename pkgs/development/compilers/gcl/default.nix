{ stdenv, fetchurl, mpfr, m4, binutils, emacs, zlib, which
, texinfo, libX11, xorgproto, libXi, gmp
, libXext, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  name = "gcl-${version}";
  version = "2.6.12";

  src = fetchurl {
    sha256 = "1s4hs2qbjqmn9h88l4xvsifq5c3dlc5s74lyb61rdi5grhdlkf4f";
    url = "http://gnu.spinellicreations.com/gcl/${name}.tar.gz";
  };

  patches = [(fetchurl {
    url = https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-lisp/gcl/files/gcl-2.6.12-gcc5.patch;
    sha256 = "00jbsn0qp8ki2w7dx8caha7g2hr9076xa6bg48j3qqqncff93zdh";
  })];

  # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=902475
  postPatch = ''
    substituteInPlace h/elf64_i386_reloc.h \
      --replace 'case R_X86_64_PC32:' 'case R_X86_64_PC32: case R_X86_64_PLT32:'
  '';

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xorgproto libXi
    libXext libXt libXaw libXmu
    zlib which texinfo
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  hardeningDisable = [ "pic" "bindnow" ];

  NIX_CFLAGS_COMPILE = "-fgnu89-inline";

  meta = with stdenv.lib; {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [ maintainers.raskin ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
