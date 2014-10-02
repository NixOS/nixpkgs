{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.73";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "01qcafrq9z55kh5q97fir13l9cg2a1ls7ijkgzj99kgc6vkc90h5";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
  };
}
