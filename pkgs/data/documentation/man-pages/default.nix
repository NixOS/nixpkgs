{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.32";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "1qr1k6kgx7i4gni9w2h610k2aa2bqdk7p08bmqslfwrzpmkkiawn";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
