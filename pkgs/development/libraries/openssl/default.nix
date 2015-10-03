{ stdenv, fetchurl, perl
, withCryptodev ? false, cryptodevHeaders }:

with stdenv.lib;
let
  opensslCrossSystem = attrByPath [ "openssl" "system" ]
    (throw "openssl needs its platform name cross building" null)
    stdenv.cross;
in
stdenv.mkDerivation rec {
  name = "openssl-1.0.2d";

  src = fetchurl {
    urls = [
      "http://www.openssl.org/source/${name}.tar.gz"
      "http://openssl.linux-mirror.org/source/${name}.tar.gz"
    ];
    sha256 = "671c36487785628a703374c652ad2cebea45fa920ae5681515df25d9f2c9a8c8";
  };

  patches = optional stdenv.isCygwin ./1.0.1-cygwin64.patch
    ++ optional (stdenv.isDarwin || (stdenv ? cross && stdenv.cross.libc == "libSystem")) ./darwin-arch.patch;

  outputs = [ "dev" "out" "man" "bin" ];
  setOutputFlags = false;

  nativeBuildInputs = [ perl ];
  buildInputs = stdenv.lib.optional withCryptodev cryptodevHeaders;

  # On x86_64-darwin, "./config" misdetects the system as
  # "darwin-i386-cc".  So specify the system type explicitly.
  configureScript =
    if stdenv.system == "x86_64-darwin" then "./Configure darwin64-x86_64-cc"
    else if stdenv.system == "x86_64-solaris" then "./Configure solaris64-x86_64-gcc"
    else "./config";

  configureFlags = [
    "shared"
    "--libdir=lib"
    "--openssldir=etc/ssl"
  ] ++ stdenv.lib.optionals withCryptodev [
    "-DHAVE_CRYPTODEV"
    "-DUSE_CRYPTODEV_DIGESTS"
  ];

  makeFlags = [ "MANDIR=$(man)/share/man" ];

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
  '';

  postFixup = ''
    # Check to make sure the main output doesn't depend on perl
    if grep -r '${perl}' $out; then
      echo "Found an erroneous dependency on perl ^^^" >&2
      exit 1
    fi
  '';

  crossAttrs = {
    preConfigure=''
      # It's configure does not like --build or --host
      export configureFlags="${concatStringsSep " " (configureFlags ++ [ opensslCrossSystem ])}"
    '';

    configureScript = "./Configure";
  };

  meta = {
    homepage = http://www.openssl.org/;
    description = "A cryptographic library that implements the SSL and TLS protocols";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.simons ];
    priority = 10; # resolves collision with ‘man-pages’
  };
}
