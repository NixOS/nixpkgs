{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libunibreak-${version}";
  version = "1.0";

  src = fetchurl {
    url = "mirror://sourceforge/vimgadgets/libunibreak/${version}/${name}.tar.gz";
    sha256 = "0rsivyxnp9nfngf83fiy4v58s5mgdhcjz75nv5nyhxwxnjq35d25";
  };

  meta = {
    homepage = http://vimgadgets.sourceforge.net/libunibreak/;
    description = "A library implementing a line breaking algorithm as described in Unicode 6.0.0 Standard";
    license = "ZLIB";
    maintainer = [ stdenv.lib.maintainers.coroa ];
  };
}
