{ stdenv, fetchurl, perl
, withCryptodev ? false, cryptodevHeaders
, enableSSL2 ? false }:

with stdenv.lib;

let

  opensslCrossSystem = stdenv.cross.openssl.system or
    (throw "openssl needs its platform name cross building");

  common = args@{ version, sha256, patches ? [] }: stdenv.mkDerivation rec {
    name = "openssl-${version}";

    src = fetchurl {
      url = "http://www.openssl.org/source/${name}.tar.gz";
      inherit sha256;
    };

    patches =
      (args.patches or [])
      ++ optional (versionOlder version "1.1.0") ./use-etc-ssl-certs.patch
      ++ optional stdenv.isCygwin ./1.0.1-cygwin64.patch
      ++ optional
           (versionOlder version "1.0.2" && (stdenv.isDarwin || (stdenv ? cross && stdenv.cross.libc == "libSystem")))
           ./darwin-arch.patch;

  outputs = [ "bin" "dev" "out" "man" ];
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
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2";

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

      rmdir $out/etc/ssl/{certs,private}
    '';

    postFixup = ''
      # Check to make sure the main output doesn't depend on perl
      if grep -r '${perl}' $out; then
        echo "Found an erroneous dependency on perl ^^^" >&2
        exit 1
      fi
    '';

    crossAttrs = {
      # upstream patch: https://rt.openssl.org/Ticket/Display.html?id=2558
      postPatch = ''
         sed -i -e 's/[$][(]CROSS_COMPILE[)]windres/$(WINDRES)/' Makefile.shared
      '';
      preConfigure=''
        # It's configure does not like --build or --host
        export configureFlags="${concatStringsSep " " (configureFlags ++ [ opensslCrossSystem ])}"
        # WINDRES and RANLIB need to be prefixed when cross compiling;
        # the openssl configure script doesn't do that for us
        export WINDRES=${stdenv.cross.config}-windres
        export RANLIB=${stdenv.cross.config}-ranlib
      '';
      configureScript = "./Configure";
    };

    meta = {
      homepage = http://www.openssl.org/;
      description = "A cryptographic library that implements the SSL and TLS protocols";
      platforms = stdenv.lib.platforms.all;
      maintainers = [ stdenv.lib.maintainers.peti ];
      priority = 10; # resolves collision with ‘man-pages’
    };
  };

in {

  openssl_1_0_1 = common {
    version = "1.0.1u";
    sha256 = "0fb7y9pwbd76pgzd7xzqfrzibmc0vf03sl07f34z5dhm2b5b84j3";
  };

  openssl_1_0_2 = common {
    version = "1.0.2j";
    sha256 = "0cf4ar97ijfc7mg35zdgpad6x8ivkdx9qii6mz35khi1ps9g5bz7";
  };

  openssl_1_1_0 = common {
    version = "1.1.0b";
    sha256 = "1xznrqvb1dbngv2k2nb6da6fdw00c01sy2i36yjdxr4vpxrf0pd4";
  };

}
