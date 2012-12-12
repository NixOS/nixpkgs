{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "spice-protocol-0.12.2";

  src = fetchurl {
    url = "http://www.spice-space.org/download/releases/${name}.tar.bz2";
    sha256 = "0v6msf6gbl8g69qamp97dggz148zpc3ncbfgbq3b472wszjdkclb";
  };

  meta = {
    description = "Protocol headers for the SPICE protocol.";
    homepage = http://www.spice-space.org;
    license = stdenv.lib.licenses.bsd3;

    maintainers = [ stdenv.lib.maintainers.bluescreen303 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
