{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.3";
    name="${baseName}-${version}";
    hash="0l1p0d7ag186hhs65kifp8jfgf4mm9rngv41bhq35d7d9gw2d2lh";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.3.tar.gz";
    sha256="0l1p0d7ag186hhs65kifp8jfgf4mm9rngv41bhq35d7d9gw2d2lh";
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
