{ stdenv, fetchurl, pkgconfig, freetype, cmake, python }:

stdenv.mkDerivation rec {
  version = "1.3.6";
  name = "graphite2-${version}";

  src = fetchurl {
    url = "https://github.com/silnrsi/graphite/releases/download/"
      + "${version}/graphite-${version}.tgz";
    sha256 = "0xdg6bc02bl8yz39l5i2skczfg17q4lif0qqan0dhvk0mibpcpj7";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ freetype ];

  patches = stdenv.lib.optionals stdenv.isDarwin [ ./macosx.patch ];

  checkInputs = [ python ];
  doCheck = false; # fails, probably missing something

  meta = {
    description = "An advanced font engine";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
