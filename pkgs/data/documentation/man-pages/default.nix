{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.82";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1c8q618shf469nfp55qrwjv9630fgq5abfk946xya9hw1bfp6wjl";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = with stdenv.lib; {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
    repositories.git = http://git.kernel.org/pub/scm/docs/man-pages/man-pages;
    maintainers = with maintainers; [ nckx ];
  };
}
