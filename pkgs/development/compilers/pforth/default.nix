{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "28";
  pname = "pforth";
  src = fetchFromGitHub {
    owner = "philburk";
    repo = "pforth";
    rev = "9190005e32c6151b76ac707b30eeb4d5d9dd1d36";
    sha256 = "0k3pmcgybsnwrxy75piyb2420r8d4ij190606js32j99062glr3x";
  };

  makeFlags = [ "SRCDIR=." ];
  makefile = "build/unix/Makefile";

  installPhase = ''
    install -Dm755 pforth_standalone $out/bin/pforth
  '';


  meta = {
    description = "Portable ANSI style Forth written in ANSI C";
    homepage = http://www.softsynth.com/pforth/;
    license = stdenv.lib.licenses.publicDomain;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ yrashk ];
  };
}
