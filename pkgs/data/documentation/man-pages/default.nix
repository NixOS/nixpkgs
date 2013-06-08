{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.50";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "04fn7zzi75y79rkg57nkync3hf14m8708iw33s03f0x8ays6fajz";
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
