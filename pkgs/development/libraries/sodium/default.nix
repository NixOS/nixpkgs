{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.7.1";
    name="${baseName}-${version}";
    hash="19w00a3vjsakw6gr24ilcj1yl2k9sh8wq3607xnyyqy2pasvnipg";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.7.1.tar.gz";
    sha256="19w00a3vjsakw6gr24ilcj1yl2k9sh8wq3607xnyyqy2pasvnipg";
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
