{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.7.0";
    name="${baseName}-${version}";
    hash="0s4iis5h7yh27kamwic3rddyp5ra941bcqcawa37grjvl78zzjjc";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.7.0.tar.gz";
    sha256="0s4iis5h7yh27kamwic3rddyp5ra941bcqcawa37grjvl78zzjjc";
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
