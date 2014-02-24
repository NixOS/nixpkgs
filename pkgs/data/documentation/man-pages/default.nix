{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.60";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0h4wzjcrz1hqbzwn1g0q11byzss7l4f1ynj7vzgbxar7z10gr5b6";
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
