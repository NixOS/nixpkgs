{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.74";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "10c6jra95ccdhz22xhmpskxcn29xvirkxzwr8dhz3jazyqwhq58y";
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
