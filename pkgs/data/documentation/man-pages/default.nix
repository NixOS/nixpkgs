{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.45";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.xz";
    sha256 = "1lwqrp79xcyhnjlyg1n0imz5wc88lpgv909xxz8bdgbk7c1mky0h";
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
