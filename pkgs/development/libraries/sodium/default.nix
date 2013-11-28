{stdenv, fetchurl}:
let
  s = # Generated upstream information
  rec {
    baseName="sodium";
    version="0.4.5";
    name="${baseName}-${version}";
    hash="0cmcw479p866r6cjh20wzjr84pdn0mfswr5h57mw1siyylnj1mbs";
    url="http://download.dnscrypt.org/libsodium/releases/libsodium-0.4.5.tar.gz";
    sha256="0cmcw479p866r6cjh20wzjr84pdn0mfswr5h57mw1siyylnj1mbs";
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
