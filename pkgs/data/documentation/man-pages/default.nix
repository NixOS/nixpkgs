{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "man-pages-3.53";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${name}.tar.xz";
    sha256 = "0kzkjfrw65f7bv6laz3jism4yqajmfh3vdq2jb5d6gyp4n14sxnl";
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
