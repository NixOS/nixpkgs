{ stdenv, fetchurl, buildPackages, perl
, buildPlatform, hostPlatform
, withCryptodev ? false, cryptodevHeaders
, enableSSL2 ? false
, static ? false
}:

with stdenv.lib;

let
  common = args@{ version, sha256, patches ? [] }: stdenv.mkDerivation rec {
    name = "openssl-${version}";

    src = fetchurl {
      url = "https://www.openssl.org/source/${name}.tar.gz";
      inherit sha256;
    };

    patches =
      (args.patches or [])
      ++ [ ./nix-ssl-cert-file.patch ]
      ++ optional (versionOlder version "1.1.0")
          (if hostPlatform.isDarwin then ./use-etc-ssl-certs-darwin.patch else ./use-etc-ssl-certs.patch)
      ++ optional (versionOlder version "1.0.2" && hostPlatform.isDarwin)
           ./darwin-arch.patch;

  postPatch = if (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isMusl) then ''
    substituteInPlace crypto/async/arch/async_posix.h \
      --replace '!defined(__ANDROID__) && !defined(__OpenBSD__)' \
                '!defined(__ANDROID__) && !defined(__OpenBSD__) && 0'
  '' else null;

    outputs = [ "bin" "dev" "out" "man" ];
    setOutputFlags = false;
    separateDebugInfo = hostPlatform.isLinux;

    nativeBuildInputs = [ perl ];
    buildInputs = stdenv.lib.optional withCryptodev cryptodevHeaders;

    # TODO(@Ericson2314): Improve with mass rebuild
    configureScript = {
        "x86_64-darwin"  = "./Configure darwin64-x86_64-cc";
        "x86_64-solaris" = "./Configure solaris64-x86_64-gcc";
      }.${hostPlatform.system} or (
        if hostPlatform == buildPlatform
          then "./config"
        else if hostPlatform.isMinGW
          then "./Configure mingw${optionalString
                                     (hostPlatform.parsed.cpu.bits != 32)
                                     (toString hostPlatform.parsed.cpu.bits)}"
        else if hostPlatform.isLinux
          then "./Configure linux-generic${toString hostPlatform.parsed.cpu.bits}"
        else if hostPlatform.isiOS
          then "./Configure ios${toString hostPlatform.parsed.cpu.bits}-cross"
        else
          throw "Not sure what configuration to use for ${hostPlatform.config}"
      );

    # TODO(@Ericson2314): Make unconditional on mass rebuild
    ${if buildPlatform != hostPlatform then "configurePlatforms" else null} = [];

    preConfigure = ''
      patchShebangs Configure
    '';

    configureFlags = [
      "shared" # "shared" builds both shared and static libraries
      "--libdir=lib"
      "--openssldir=etc/ssl"
    ] ++ stdenv.lib.optionals withCryptodev [
      "-DHAVE_CRYPTODEV"
      "-DUSE_CRYPTODEV_DIGESTS"
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2"
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && hostPlatform.isAarch64) "no-afalgeng";

    makeFlags = [ "MANDIR=$(man)/share/man" ];

    enableParallelBuilding = true;

    postInstall =
    stdenv.lib.optionalString (!static) ''
      # If we're building dynamic libraries, then don't install static
      # libraries.
      if [ -n "$(echo $out/lib/*.so $out/lib/*.dylib $out/lib/*.dll)" ]; then
          rm "$out/lib/"*.a
      fi

    '' +
    ''
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
    version = "1.0.2o";
    sha256 = "0kcy13l701054nhpbd901mz32v1kn4g311z0nifd83xs2jbmqgzc";
  };

  openssl_1_1_0 = common {
    version = "1.1.0h";
    sha256 = "05x509lccqjscgyi935z809pwfm708islypwhmjnb6cyvrn64daq";
  };

}
