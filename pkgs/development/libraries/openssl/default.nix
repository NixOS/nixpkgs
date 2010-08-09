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
  
  # On x86_64-darwin, "./config" misdetects the system as
  # "darwin-i386-cc".  So specify the system type explicitly.
  configureScript =
    if stdenv.system == "x86_64-darwin" then "./Configure darwin64-x86_64-cc" else "./config";
  
  configureFlags = "shared --libdir=lib";

  crossAttrs = {
    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="--libdir=lib --cross-compile-prefix=${stdenv.cross.config}- shared ${opensslCrossSystem}"
    '';

    # Openssl installs readonly files, which otherwise we can't strip.
    # This could at some stdenv hash change be put out of crossAttrs, too
    postInstall = ''
      chmod -R +w $out
    '';
    configureScript = "./Configure";
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
}
