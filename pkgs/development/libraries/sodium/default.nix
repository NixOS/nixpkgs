{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="1.0.0";
    name="${baseName}-${version}";
    hash="19f9vf0shfp4rc4l791r6xjg06z4i8psj1zkjkm3z5b640yzxlff";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-1.0.0.tar.gz";
    sha256="19f9vf0shfp4rc4l791r6xjg06z4i8psj1zkjkm3z5b640yzxlff";
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
