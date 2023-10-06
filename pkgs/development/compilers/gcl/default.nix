{ lib, stdenv, fetchurl, mpfr, m4, binutils, emacs, zlib, which
, texinfo, libX11, xorgproto, libXi, gmp
, libXext, libXt, libXaw, libXmu } :

assert stdenv ? cc ;
assert stdenv.cc.isGNU ;
assert stdenv.cc ? libc ;
assert stdenv.cc.libc != null ;

stdenv.mkDerivation rec {
  pname = "gcl";
  version = "2.6.12";

  src = fetchurl {
    sha256 = "1s4hs2qbjqmn9h88l4xvsifq5c3dlc5s74lyb61rdi5grhdlkf4f";
    url = "http://gnu.spinellicreations.com/gcl/${pname}-${version}.tar.gz";
  };

  patches = [(fetchurl {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-lisp/gcl/files/gcl-2.6.12-gcc5.patch";
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

  # -fcommon: workaround build failure on -fno-common toolchains:
  #   ld: ./libgclp.a(user_match.o):(.bss+0x18): multiple definition of
  #     `tf'; ./libpre_gcl.a(main.o):(.bss+0x326d90): first defined here
  env.NIX_CFLAGS_COMPILE = "-fgnu89-inline -fcommon";

  meta = with lib; {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = lib.teams.lisp.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
