{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.4.3";
    name="${baseName}-${version}";
    hash="0hk0zca1kpj6xlc2j2qx9qy7287pi0896frmxq5d7qmcwsdf372r";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.4.3.tar.gz";
    sha256="0hk0zca1kpj6xlc2j2qx9qy7287pi0896frmxq5d7qmcwsdf372r";
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
