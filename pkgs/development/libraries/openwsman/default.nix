{ fetchurl, stdenv, autoconf, automake, libtool, pkgconfig, libxml2, curl, cmake, pam, sblim-sfcc }:

stdenv.mkDerivation rec {
  version = "2.6.0";
  name = "openwsman-${version}";

  src = fetchurl {
    url = "https://github.com/Openwsman/openwsman/archive/v${version}.tar.gz";
    sha256 = "0gw2dsjxzpchg3s85kplwgp9xhd9l7q4fh37iy7r203pvir4k6s4";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libxml2 curl cmake pam sblim-sfcc ];

  cmakeFlags = [
    "-DCMAKE_BUILD_RUBY_GEM=no"
  ];

  preConfigure = ''
    cmakeFlags="$cmakeFlags -DPACKAGE_ARCHITECTURE=$(uname -m)";
  '';

  configureFlags = "--disable-more-warnings";

  meta = {
    description = "Openwsman server implementation and client api with bindings";

    homepage = https://github.com/Openwsman/openwsman;
    downloadPage = "https://github.com/Openwsman/openwsman/releases";

    maintainers = [ stdenv.lib.maintainers.deepfire ];

    license = stdenv.lib.licenses.bsd3;

    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice

    inherit version;
  };
}
