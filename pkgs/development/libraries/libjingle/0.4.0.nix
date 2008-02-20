args: with args;

stdenv.mkDerivation rec {
  name = "libjingle-" + version;

  src = fetchurl {
    url = "mirror://sf/libjingle/${name}.tar.gz";
    sha256 = "0izg1i4nmhysvkqmsl2xqp0x6lwz2jjyavvhv196hsdsr2w0iwvi";
  };
}
