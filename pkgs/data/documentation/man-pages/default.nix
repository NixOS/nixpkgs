{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.54";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0rb75dl9hh4v2s95bcssy12j8qrbd2dmlzry68gphyxk5c7yipbl";
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
