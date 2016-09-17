{ stdenv, fetchFromGitHub, perl, zlib
, withCryptodev ? false, cryptodevHeaders
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openssl-chacha-${version}";
  version = "2016-08-22";

  src = fetchFromGitHub {
    owner = "PeterMosmans";
    repo = "openssl";
    rev = "293717318e903b95f4d7e83a98a087282f37efc3";
    sha256 = "134j3anjnj2q99xsd8d47bwvjp73qkdsimdd9riyjxa3hd8ysr00";
  };

  outputs = [ "bin" "dev" "out" "man" ];
  setOutputFlags = false;

  nativeBuildInputs = [ perl zlib ];
  buildInputs = stdenv.lib.optional withCryptodev cryptodevHeaders;

  configureScript = "./config";

  configureFlags = [
    "zlib"
    "shared"
    "experimental-jpake"
    "enable-md2"
    "enable-rc5"
    "enable-rfc3779"
    "enable-gost"
    "--libdir=lib"
    "--openssldir=etc/ssl"
  ] ++ stdenv.lib.optionals withCryptodev [
    "-DHAVE_CRYPTODEV"
    "-DUSE_CRYPTODEV_DIGESTS"
  ];

  makeFlags = [
    "MANDIR=$(man)/share/man"
  ];

  # Parallel building is broken in OpenSSL.
  enableParallelBuilding = false;

  postInstall = ''
    # If we're building dynamic libraries, then don't install static
    # libraries.
    if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
        rm "$out/lib/"*.a
    fi

    mkdir -p $bin
    mv $out/bin $bin/

    mkdir $dev
    mv $out/include $dev/

    # remove dependency on Perl at runtime
    rm -r $out/etc/ssl/misc

    rmdir $out/etc/ssl/{certs,private}
  '';

  postFixup = ''
    # Check to make sure we don't depend on perl
    if grep -r '${perl}' $out; then
      echo "Found an erroneous dependency on perl ^^^" >&2
      exit 1
    fi
  '';

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    platforms = [ "x86_64-linux" ];
    maintainers = [ stdenv.lib.maintainers.cstrahan ];
    priority = 10; # resolves collision with ‘man-pages’
  };
}
