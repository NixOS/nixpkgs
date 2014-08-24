{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.70";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1qnhlicshlcz2da9k9czp75cfj7a6y90m0bhik7gzxa3s3b4f43j";
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
