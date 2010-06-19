{ stdenv, fetchurl, perl }:

let
  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation ( rec {
  name = "openssl-0.9.8n";
  
  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha256 = "008z1h09pa6dfxs4wgbqj5i1clw4v82b1waqvwanb1kb6wlbq6mh";
  };

  buildNativeInputs = [ perl ];

  configureScript = "./config";
  
  configureFlags = "shared";

  crossAttrs = {
    configurePhase = ''
      export cross=$crossSystem-
      ./Configure --prefix=$out ${opensslCrossSystem} shared
    '';
    buildPhase = ''
      make CC=$crossConfig-gcc \
        AR="$crossConfig-ar r" \
        RANLIB=$crossConfig-ranlib
    '';
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
} // (if stdenv.isDarwin then { patches = [./darwin-arch.patch]; } else {}) )
