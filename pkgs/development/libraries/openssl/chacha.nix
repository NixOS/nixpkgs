{ stdenv, fetchFromGitHub, perl, zlib
, withCryptodev ? false, cryptodevHeaders
}:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openssl-chacha-${version}";
  version = "2016-01-27";

  src = fetchFromGitHub {
    owner = "PeterMosmans";
    repo = "openssl";
    rev = "4576ede5b08242bcd6749fc284c691ed177842b7";
    sha256 = "1030rs4bdaysxbq0mmck1dn6g5adspzkwsrnhvv16b4ig0r4ncgj";
  };

  outputs = [ "dev" "out" "man" "bin" ];
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
