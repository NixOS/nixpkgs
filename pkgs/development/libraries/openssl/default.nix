{ stdenv, fetchurl, perl }:

let
  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation rec {
  name = "openssl-0.9.8l";
  
  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha1 = "d3fb6ec89532ab40646b65af179bb1770f7ca28f";
  };

  patches = [ ./darwin-arch.patch ];
  
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
}
