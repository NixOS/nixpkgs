{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="1.0.1";
    name="${baseName}-${version}";
    hash="1x9src824c3ansgvnphhnnnnyrd0spspf7hwmxijv7pglj3hh2f3";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-1.0.1.tar.gz";
    sha256="1x9src824c3ansgvnphhnnnnyrd0spspf7hwmxijv7pglj3hh2f3";
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
