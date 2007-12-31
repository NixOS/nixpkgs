args: with args;
stdenv.mkDerivation {
  name = "libwpd-0.8.13";
  src = fetchurl {
    url = mirror://sourceforge/libwpd/libwpd-0.8.13.tar.gz;
    sha256 = "08mb8bp0d3387l1snii4c0ighfhkby7qx2b3wymqb4a0l76rlzfn";
  };
  buildInputs = [pkgconfig glib libgsf libxml2 bzip2];
}
