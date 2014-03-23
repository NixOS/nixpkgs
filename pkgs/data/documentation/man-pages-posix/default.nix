{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "man-pages-posix-2013-a";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-posix/${name}.tar.xz";
    sha256 = "0258j05zdrxpgdj8nndbyi7bvrs8fxdksb0xbfrylzgzfmf3lqqr";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "POSIX man-pages (0p, 1p, 3p)";
    homepage = http://kernel.org/pub/linux/docs/manpages/;
  };
}
