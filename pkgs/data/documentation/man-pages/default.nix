{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.48";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "6944cc3ad5131abab01c6703e63672b2e44be52737cdb1144f6ddaebb7f7d682";
  };

  preBuild =
    ''
      makeFlagsArray=(MANDIR=$out/share/man)
    '';

  meta = {
    description = "Linux development manual pages";
    homepage = http://www.kernel.org/doc/man-pages/;
  };
}
