{ stdenv, fetchurl, perl }:

let
  opensslCrossSystem = stdenv.lib.attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in

stdenv.mkDerivation rec {
  name = "openssl-1.0.0e";

  src = fetchurl {
    url = "http://www.openssl.org/source/${name}.tar.gz";
    sha256 = "1xw0ffzmr4wbnb0glywgks375dvq8x87pgxmwx6vhgvkflkxqqg3";
  };

  patches = stdenv.lib.optional stdenv.isDarwin ./darwin-arch.patch;

  buildNativeInputs = [ perl ];
  
  # On x86_64-darwin, "./config" misdetects the system as
  # "darwin-i386-cc".  So specify the system type explicitly.
  configureScript =
    if stdenv.system == "x86_64-darwin" then "./Configure darwin64-x86_64-cc" else "./config";
  
  configureFlags = "shared --libdir=lib";

  makeFlags = "MANDIR=$(out)/share/man";

  postInstall =
    ''
      # If we're building dynamic libraries, then don't install static
      # libraries.
      if [ -n "$(echo $out/lib/*.so)" ]; then
          rm $out/lib/*.a
      fi
    ''; # */

  crossAttrs = {
    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="--libdir=lib --cross-compile-prefix=${stdenv.cross.config}- shared ${opensslCrossSystem}"
    '';

    postInstall = ''
      # Openssl installs readonly files, which otherwise we can't strip.
      # This could at some stdenv hash change be put out of crossAttrs, too
      chmod -R +w $out

      # Remove references to perl, to avoid depending on it at runtime
      rm $out/bin/c_rehash $out/ssl/misc/CA.pl $out/ssl/misc/tsget
    '';
    configureScript = "./Configure";
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
  };
}
