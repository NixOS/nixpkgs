{ stdenv, fetchurl, mpfr, m4, binutils, fetchcvs, emacs, zlib, which
, texinfo, libX11, xproto, inputproto, libXi, gmp
, libXext, xextproto, libXt, libXaw, libXmu } :

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

  buildInputs = [
    mpfr m4 binutils emacs gmp
    libX11 xproto inputproto libXi
    libXext xextproto libXt libXaw libXmu
    zlib which texinfo
  ];

  configureFlags = [
    "--enable-ansi"
  ];

  # Upstream bug submitted - http://savannah.gnu.org/bugs/index.php?30371
  # $TMPDIR must have no extension
  # setVars = a.noDepEntry ''
  #   export TMPDIR="''${TMPDIR:-''${TMP:-''${TEMP}}}/tmp-for-gcl"
  #   mkdir -p "$TMPDIR"
  # '';

  preBuild = ''
    # sed -re "s@/bin/cat@$(which cat)@g" -i configure */configure
    # sed -re "s@if test -d /proc/self @if false @" -i configure
    # sed -re 's^([ \t])cpp ^\1cpp -I${stdenv.cc.cc}/include -I${stdenv.cc.libc}/include ^g' -i makefile
  '';

  /* doConfigure should be removed if not needed */
  # phaseNames = ["setVars" "doUnpack" "preBuild"
  #   "doConfigure" "doMakeInstall"];

  meta = {
    description = "GNU Common Lisp compiler working via GCC";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
