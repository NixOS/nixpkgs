args: with args;
stdenv.mkDerivation {
  name = "libwpd-0.8.5";
  src = fetchurl {
    url = mirror://sourceforge/libwpd/libwpd-0.8.5.tar.gz;
    md5 = "6b679e205a2805c3d23f41c65b35e266";
  };
  buildInputs = [pkgconfig glib libgsf libxml2 bzip2];
}
