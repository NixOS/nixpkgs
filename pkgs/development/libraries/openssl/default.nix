{ stdenv, fetchurl, perl }:

let
  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation (rec {
  name = "openssl-1.0.0";
  
  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha1 = "3f800ea9fa3da1c0f576d689be7dca3d55a4cb62";
  };

  buildNativeInputs = [ perl ];

  configureScript = "./config";
  
  configureFlags="--libdir=lib shared";

  crossAttrs = {
    preConfigure=''
      export cross=$crossSystem-
    '';
    configureFlags="--libdir=lib ${opensslCrossSystem} shared";
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
//
(if stdenv.isDarwin then {
  patches = ./darwin-arch.patch;
}
else { })
)
