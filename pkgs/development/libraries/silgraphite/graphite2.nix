{ stdenv, fetchurl, pkgconfig, freetype, cmake }:

stdenv.mkDerivation rec {
  version = "1.3.6";
  name = "graphite2-${version}";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/graphite-${version}.tgz";
    sha256 = "0xdg6bc02bl8yz39l5i2skczfg17q4lif0qqan0dhvk0mibpcpj7";
  };

  buildInputs = [ pkgconfig freetype cmake ];

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  meta = {
    description = "An advanced font engine";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    hydraPlatforms = stdenv.lib.platforms.unix;
  };
}
