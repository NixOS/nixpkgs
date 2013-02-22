{ stdenv, fetchurl, libtool, gcc, patches ? []}:

stdenv.mkDerivation {
  name = "opencxx-2.8";
  src = fetchurl {
    url = mirror://sourceforge/opencxx/opencxx-2.8.tar.gz;
    md5 = "0f71df82751fe8aba5122d6e0541c98a";
  };

  buildInputs = [libtool];
  NIX_GCC = gcc;

  inherit patches;
}
