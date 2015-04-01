{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="1.0.2";
    name="${baseName}-${version}";
    hash="06dabf77cz6qg7aqv5j5r4m32b5zn253pixwb3k5lm3z0h88y7cn";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-1.0.2.tar.gz";
    sha256="06dabf77cz6qg7aqv5j5r4m32b5zn253pixwb3k5lm3z0h88y7cn";
  };
  buildInputs = [
  ];
in
stdenv.mkDerivation {
  inherit (s) name version;
  inherit buildInputs;
  src = fetchurl {
    inherit (s) url sha256;
  };
  meta = {
    inherit (s) version;
    description = ''A cryptography library with simple API'';
    license = stdenv.lib.licenses.mit ;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
