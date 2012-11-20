{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.43";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/Archive/${name}.tar.xz";
    sha256 = "05fjq8llfxm77mnf2jhly98780xbkakim7b7hbx6kafvvs5zisrf";
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
