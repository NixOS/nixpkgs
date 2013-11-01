{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnet-${version}";
  version = "1.2-rc2";

  src = fetchurl {
    url = "mirror://sourceforge/libnet-dev/${name}.tar.gz";
    sha256 = "1pc74p839a7wvhjdgy0scj7c4yarr6mqdqvj56k6sp8pkc763az7";
  };

  meta = {
    homepage = http://github.com/sam-github/libnet;
    description = "Portable framework for low-level network packet construction";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
