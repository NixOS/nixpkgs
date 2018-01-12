{ stdenv, fetchurl, buildPackages, perl
, hostPlatform
, fetchpatch
, withCryptodev ? false, cryptodevHeaders
, enableSSL2 ? false
}:

with stdenv.lib;

let

  opensslCrossSystem = hostPlatform.openssl.system or
    (throw "openssl needs its platform name cross building");

  common = args@{ version, sha256, patches ? [] }: stdenv.mkDerivation rec {
    name = "openssl-${version}";

    src = fetchurl {
      url = "http://www.openssl.org/source/${name}.tar.gz";
      inherit sha256;
    };

    patches =
      (args.patches or [])
      ++ [ ./nix-ssl-cert-file.patch ]
      ++ optional (versionOlder version "1.1.0")
          (if stdenv.isDarwin then ./use-etc-ssl-certs-darwin.patch else ./use-etc-ssl-certs.patch)
      ++ optional (versionOlder version "1.0.2" && hostPlatform.isDarwin)
           ./darwin-arch.patch;

    outputs = [ "bin" "dev" "out" "man" ];
    setOutputFlags = false;
    separateDebugInfo = stdenv.isLinux;

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
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2"
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && stdenv.isAarch64) "no-afalgeng";

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
      if grep -r '${buildPackages.perl}' $out; then
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
      '';
      configureScript = "./Configure";
    };

    meta = {
      homepage = https://www.openssl.org/;
      description = "A cryptographic library that implements the SSL and TLS protocols";
      platforms = stdenv.lib.platforms.all;
      maintainers = [ stdenv.lib.maintainers.peti ];
      priority = 10; # resolves collision with ‘man-pages’
    };
  };

in {

  openssl_1_0_2 = common {
    version = "1.0.2n";
    sha256 = "1zm82pyq5a9jm10q6iv7d3dih3xwjds4x30fqph3k317byvsn2rp";
  };

  openssl_1_1_0 = common {
    version = "1.1.0g";
    sha256 = "1bvka2wf33w2vxv7yw578nnjqyhz2b3chvfb0l4k2ffscw950kfy";
    patches = [
      (fetchpatch {
        name = "CVE-2017-3738.patch";
        url = "https://github.com/openssl/openssl/commit/563066.patch";
        sha256 = "0ni9fwpxf8raw8b58pfa15akbqmxx4q64v0ldsm4b9dqhbxf8mkz";
      })
    ];
  };

}
