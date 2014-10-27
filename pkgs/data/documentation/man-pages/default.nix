{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.75";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1xnja13a3zb7gzcsdn7sx962lk6mj8m3rz1w7fpgvhsq745cmah6";
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
