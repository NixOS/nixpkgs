{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "dev86-0.16.18";
  
  src = fetchurl {
    url = http://www.debath.co.uk/dev86/Dev86src-0.16.18.tar.gz;
    sha256 = "1wcg2x8i2fq7kqgazx2il3qfmikyi4kfb23vm45yxlwq72l55604";
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
