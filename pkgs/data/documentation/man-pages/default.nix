{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.35";
  
  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.bz2";
    sha256 = "186zn80k10jg1m4jp5x5x73f7cczydsjcw5zxc5d9lls5wvafp66";
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
