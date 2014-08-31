{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.71";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "981038ecffcf6db490c0bc4359f489c318654068a6ba5aa086962ac41b0d2894";
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
