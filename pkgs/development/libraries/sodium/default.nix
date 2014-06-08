{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.5.0";
    name="${baseName}-${version}";
    hash="1w7rrnsvhhzhywrr3nhlhppv4kqzdszz3dwy8jrsv8lrj5hs181w";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.5.0.tar.gz";
    sha256="1w7rrnsvhhzhywrr3nhlhppv4kqzdszz3dwy8jrsv8lrj5hs181w";
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
