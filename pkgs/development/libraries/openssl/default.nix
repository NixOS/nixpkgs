{ stdenv, fetchurl, perl }:

let
  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation rec {
  name = "openssl-1.0.0a";

  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha256 = "0qqgyzfb0alwx329z8bqybzamfl9j2maykykvq6zk3ibq0gvva8q";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin-arch.patch;

  buildNativeInputs = [ perl ];

  configureScript = "./config";
  
  configureFlags = "shared --libdir=lib";

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
