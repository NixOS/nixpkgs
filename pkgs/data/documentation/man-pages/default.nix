{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.78";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0zm3sc0zbfng440jjqha8qnzivvg5nqpwgi7zv9h8qxwgyhrfa65";
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
