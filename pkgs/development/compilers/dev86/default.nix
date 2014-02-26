{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "dev86-0.16.19";

  src = fetchurl {
    url = http://www.debath.co.uk/dev86/Dev86src-0.16.19.tar.gz;
    sha256 = "33398b87ca85e2b69e4062cf59f2f7354af46da5edcba036c6f97bae17b8d00e";
  };

  makeFlags = "PREFIX=$(out)";

  # Awful hackery to get dev86 to compile with recent gcc/binutils.
  # See http://bugs.gentoo.org/214964 for some inconclusive
  # discussion.
  preBuild =
    ''
      substituteInPlace makefile.in --replace "-O2" "" --replace "-O" ""
    '';

  meta = {
    description = "Linux 8086 development environment";
    homepage = http://www.debath.co.uk/;
  };
}
