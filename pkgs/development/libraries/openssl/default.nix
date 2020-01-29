{ stdenv, fetchurl, buildPackages, perl, coreutils
, withCryptodev ? false, cryptodev
, enableSSL2 ? false
, static ? false
}:

with stdenv.lib;

let
  common = { version, sha256, patches ? [], withDocs ? false }: stdenv.mkDerivation rec {
    pname = "openssl";
    inherit version;

    src = fetchurl {
      url = "https://www.openssl.org/source/${pname}-${version}.tar.gz";
      inherit sha256;
    };

    inherit patches;

    postPatch = ''
      patchShebangs Configure
    '' + optionalString (versionOlder version "1.1.0") ''
      patchShebangs test/*
      for a in test/t* ; do
        substituteInPlace "$a" \
          --replace /bin/rm rm
      done
    '' + optionalString (versionAtLeast version "1.1.1") ''
      substituteInPlace config --replace '/usr/bin/env' '${coreutils}/bin/env'
    '' + optionalString (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isMusl) ''
      substituteInPlace crypto/async/arch/async_posix.h \
        --replace '!defined(__ANDROID__) && !defined(__OpenBSD__)' \
                  '!defined(__ANDROID__) && !defined(__OpenBSD__) && 0'
    '';

    outputs = [ "bin" "dev" "out" "man" ] ++ optional withDocs "doc";
    setOutputFlags = false;
    separateDebugInfo = !(stdenv.hostPlatform.useLLVM or false) && stdenv.cc.isGNU;

    nativeBuildInputs = [ perl ];
    buildInputs = stdenv.lib.optional withCryptodev cryptodev;

    # TODO(@Ericson2314): Improve with mass rebuild
    configurePlatforms = [];
    configureScript = {
        armv6l-linux = "./Configure linux-armv4 -march=armv6";
        armv7l-linux = "./Configure linux-armv4 -march=armv7-a";
        x86_64-darwin  = "./Configure darwin64-x86_64-cc";
        x86_64-linux = "./Configure linux-x86_64";
        x86_64-solaris = "./Configure solaris64-x86_64-gcc";
      }.${stdenv.hostPlatform.system} or (
        if stdenv.hostPlatform == stdenv.buildPlatform
          then "./config"
        else if stdenv.hostPlatform.isMinGW
          then "./Configure mingw${optionalString
                                     (stdenv.hostPlatform.parsed.cpu.bits != 32)
                                     (toString stdenv.hostPlatform.parsed.cpu.bits)}"
        else if stdenv.hostPlatform.isLinux
          then "./Configure linux-generic${toString stdenv.hostPlatform.parsed.cpu.bits}"
        else if stdenv.hostPlatform.isiOS
          then "./Configure ios${toString stdenv.hostPlatform.parsed.cpu.bits}-cross"
        else
          throw "Not sure what configuration to use for ${stdenv.hostPlatform.config}"
      );

    configureFlags = [
      "shared" # "shared" builds both shared and static libraries
      "--libdir=lib"
      "--openssldir=etc/ssl"
    ] ++ stdenv.lib.optionals withCryptodev [
      "-DHAVE_CRYPTODEV"
      "-DUSE_CRYPTODEV_DIGESTS"
    ] ++ stdenv.lib.optional enableSSL2 "enable-ssl2"
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && stdenv.hostPlatform.isAarch64) "no-afalgeng"
      # OpenSSL needs a specific `no-shared` configure flag.
      # See https://wiki.openssl.org/index.php/Compilation_and_Installation#Configure_Options
      # for a comprehensive list of configuration options.
      ++ stdenv.lib.optional (versionAtLeast version "1.1.0" && static) "no-shared";

    makeFlags = [
      "MANDIR=$(man)/share/man"
      # This avoids conflicts between man pages of openssl subcommands (for
      # example 'ts' and 'err') man pages and their equivalent top-level
      # command in other packages (respectively man-pages and moreutils).
      # This is done in ubuntu and archlinux, and possiibly many other distros.
      "MANSUFFIX=ssl"
    ];

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
    '' + stdenv.lib.optionalString (!stdenv.hostPlatform.isWindows)
    ''
      substituteInPlace $out/bin/c_rehash --replace ${buildPackages.perl} ${perl}
    '' +
    ''
      mv $out/bin $bin/

      mkdir $dev
      mv $out/include $dev/

      # remove dependency on Perl at runtime
      rm -r $out/etc/ssl/misc

      rmdir $out/etc/ssl/{certs,private}
    '';

    postFixup = stdenv.lib.optionalString (!stdenv.hostPlatform.isWindows) ''
      # Check to make sure the main output doesn't depend on perl
      if grep -r '${buildPackages.perl}' $out; then
        echo "Found an erroneous dependency on perl ^^^" >&2
        exit 1
      fi
    '';

    meta = with stdenv.lib; {
      homepage = https://www.openssl.org/;
      description = "A cryptographic library that implements the SSL and TLS protocols";
      license = licenses.openssl;
      platforms = platforms.all;
      maintainers = [ maintainers.peti ];
    };
  };

in {

  openssl_1_0_2 = common {
    version = "1.0.2u";
    sha256 = "ecd0c6ffb493dd06707d38b14bb4d8c2288bb7033735606569d8f90f89669d16";
    patches = [
      ./1.0.2/nix-ssl-cert-file.patch

      (if stdenv.hostPlatform.isDarwin
       then ./1.0.2/use-etc-ssl-certs-darwin.patch
       else ./1.0.2/use-etc-ssl-certs.patch)
    ];
  };

  openssl_1_1 = common {
    version = "1.1.1d";
    sha256 = "1whinyw402z3b9xlb3qaxv4b9sk4w1bgh9k0y8df1z4x3yy92fhy";
    patches = [
      ./1.1/nix-ssl-cert-file.patch

      (if stdenv.hostPlatform.isDarwin
       then ./1.1/use-etc-ssl-certs-darwin.patch
       else ./1.1/use-etc-ssl-certs.patch)
    ];
    withDocs = true;
  };

}
