{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "man-pages-posix";
  version = "2017-a";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-posix/${pname}-${version}.tar.xz";
    sha256 = "ce67bb25b5048b20dad772e405a83f4bc70faf051afa289361c81f9660318bc3";
  };

  makeFlags = [
    "MANDIR=${placeholder "out"}/share/man"
  ];

  meta = {
    description = "POSIX man-pages (0p, 1p, 3p)";
    homepage = "https://www.kernel.org/doc/man-pages/";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
