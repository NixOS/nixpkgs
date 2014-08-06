{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.6.1";
    name="${baseName}-${version}";
    hash="151nril3kzkpmy6khvqphk4zk15ri0dqv0isyyhz6n9nsbmzxk04";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.6.1.tar.gz";
    sha256="151nril3kzkpmy6khvqphk4zk15ri0dqv0isyyhz6n9nsbmzxk04";
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
