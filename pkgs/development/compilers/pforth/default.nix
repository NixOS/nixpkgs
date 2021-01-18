{ stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation {
  version = "28";
  pname = "pforth";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "pforth";
    rev = "9190005e32c6151b76ac707b30eeb4d5d9dd1d36";
    sha256 = "0k3pmcgybsnwrxy75piyb2420r8d4ij190606js32j99062glr3x";
  };

  patches = [
    (fetchpatch {
      name = "gnumake-4.3-fix.patch";
      url = "https://github.com/philburk/pforth/commit/457cb99f57292bc855e53abcdcb7b12d6681e847.patch";
      sha256 = "0x1bwx3pqb09ddjhmdli47lnk1ys4ny42819g17kfn8nkjs5hbx7";
    })
  ];

  makeFlags = [ "SRCDIR=." ];
  makefile = "build/unix/Makefile";

  installPhase = ''
    install -Dm755 pforth_standalone $out/bin/pforth
  '';


  meta = {
    description = "Portable ANSI style Forth written in ANSI C";
    homepage = "http://www.softsynth.com/pforth/";
    license = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ yrashk ];
  };
}
