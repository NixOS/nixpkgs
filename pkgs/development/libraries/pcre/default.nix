args: with args;

stdenv.mkDerivation ({
  name = "pcre-7.1";
  src = fetchurl {
    url = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.1.tar.bz2;
    sha256 = "0rpkcw07jas3fw6ava3ni5zcrmbncwa8xlsa0lzq6z2iph5510li";
  };
}
// (if unicodeSupport then
{
  configureFlags = "--enable-unicode-properties --enable-shared --disable-static";
}
else {}))
