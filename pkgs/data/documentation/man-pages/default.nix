{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.72";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0lw62qvbbnxk19q7ca6kcwb0qxqh1rrf39m35bm5fwirqw8dmr7y";
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
