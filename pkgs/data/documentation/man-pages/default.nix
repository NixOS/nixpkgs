{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.62";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "1pxnbznrzckzdnlfbdsg9hjd2g93q6b433l4gp095kdxxjqm1mgk";
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
