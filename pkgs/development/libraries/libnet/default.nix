{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnet-${version}";
  version = "1.2-rc3";

  src = fetchurl {
    url = "mirror://sourceforge/libnet-dev/${name}.tar.gz";
    sha256 = "0qsapqa7dzq9f6lb19kzilif0pj82b64fjv5bq086hflb9w81hvj";
  };

  patches = [ ./fix-includes.patch ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sam-github/libnet;
    description = "Portable framework for low-level network packet construction";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
