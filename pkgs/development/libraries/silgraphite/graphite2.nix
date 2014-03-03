{ stdenv, fetchurl, pkgconfig, freetype, cmake }:

stdenv.mkDerivation rec {
  version = "1.2.4";
  name = "graphite2-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/silgraphite/graphite2/${name}.tgz";
    sha256 = "00xhv1mp640fr3wmdzwn4yz0g56jd4r9fb7b02mc1g19h0bdbhsb";
  };

  buildInputs = [ pkgconfig freetype cmake ];

  meta = {
    description = "An advanced font engine";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    hydraPlatforms = stdenv.lib.platforms.unix;
  };
}
