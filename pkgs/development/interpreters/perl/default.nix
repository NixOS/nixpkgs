{ lib, stdenv, fetchurlBoot, buildPackages, enableThreading ? stdenv ? glibc }:

with lib;

# We can only compile perl with threading on platforms where we have a
# real glibc in the stdenv.
#
# Instead of silently building an unthreaded perl if this is not the
# case, we force callers to disableThreading explicitly, therefore
# documenting the platforms where the perl is not threaded.
#
# In the case of stdenv linux boot stage1 it's not possible to use
# threading because of the simpleness of the bootstrap glibc, so we
# use enableThreading = false there.
assert enableThreading -> (stdenv ? glibc);

let

  libc = if stdenv.cc.libc or null != null then stdenv.cc.libc else "/usr";
  libcInc = lib.getDev libc;
  libcLib = lib.getLib libc;
  crossCompiling = stdenv.buildPlatform != stdenv.hostPlatform;
  common = { version, sha256 }: stdenv.mkDerivation (rec {
    name = "perl-${version}";

    src = fetchurlBoot {
      url = "mirror://cpan/src/5.0/${name}.tar.gz";
      inherit sha256;
    };

    # TODO: Add a "dev" output containing the header files.
    outputs = [ "out" "man" "devdoc" ];
    setOutputFlags = false;

    patches =
      [ ]
      # Do not look in /usr etc. for dependencies.
      ++ optional (versionOlder version "5.26") ./no-sys-dirs.patch
      ++ optional (versionAtLeast version "5.26") ./no-sys-dirs-5.26.patch
      ++ optional (versionAtLeast version "5.24") (
        # Fix parallel building: https://rt.perl.org/Public/Bug/Display.html?id=132360
        fetchurlBoot {
          url = "https://rt.perl.org/Public/Ticket/Attachment/1502646/807252/0001-Fix-missing-build-dependency-for-pods.patch";
          sha256 = "1bb4mldfp8kq1scv480wm64n2jdsqa3ar46cjp1mjpby8h5dr2r0";
        })
      ++ optional stdenv.isSunOS ./ld-shared.patch
      ++ optional stdenv.isDarwin ./cpp-precomp.patch
      ++ optional (stdenv.isDarwin && versionAtLeast version "5.24") ./sw_vers.patch;

    postPatch = ''
      pwd="$(type -P pwd)"
      substituteInPlace dist/PathTools/Cwd.pm \
        --replace "/bin/pwd" "$pwd"
    '' + stdenv.lib.optionalString crossCompiling ''
      substituteInPlace cnf/configure_tool.sh --replace "cc -E -P" "cc -E"
    '';

    # Build a thread-safe Perl with a dynamic libperls.o.  We need the
    # "installstyle" option to ensure that modules are put under
    # $out/lib/perl5 - this is the general default, but because $out
    # contains the string "perl", Configure would select $out/lib.
    # Miniperl needs -lm. perl needs -lrt.
    configureFlags =
      (if crossCompiling
       then [ "-Dlibpth=\"\"" "-Dglibpth=\"\"" ]
       else [ "-de" "-Dcc=cc" ])
      ++ [
        "-Uinstallusrbinperl"
        "-Dinstallstyle=lib/perl5"
        "-Duseshrplib"
        "-Dlocincpth=${libcInc}/include"
        "-Dloclibpth=${libcLib}/lib"
      ]
      ++ optional stdenv.isSunOS "-Dcc=gcc"
      ++ optional enableThreading "-Dusethreads";

    configureScript = stdenv.lib.optionalString (!crossCompiling) "${stdenv.shell} ./Configure";

    dontAddPrefix = !crossCompiling;

    enableParallelBuilding = !crossCompiling;

    preConfigure = optionalString (!crossCompiling) ''
        configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"
      '' + optionalString (stdenv.isArm || stdenv.isMips) ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      '' + optionalString stdenv.isDarwin ''
        substituteInPlace hints/darwin.sh --replace "env MACOSX_DEPLOYMENT_TARGET=10.3" ""
      '' + optionalString (!enableThreading) ''
        # We need to do this because the bootstrap doesn't have a static libpthread
        sed -i 's,\(libswanted.*\)pthread,\1,g' Configure
      '';

    preBuild = optionalString (!(stdenv ? cc && stdenv.cc.nativeTools))
      ''
        # Make Cwd work on NixOS (where we don't have a /bin/pwd).
        substituteInPlace dist/PathTools/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
      '';

    setupHook = ./setup-hook.sh;

    passthru.libPrefix = "lib/perl5/site_perl";

    # TODO: it seems like absolute paths to some coreutils is required.
    postInstall =
      ''
        # Remove dependency between "out" and "man" outputs.
        rm "$out"/lib/perl5/*/*/.packlist

        # Remove dependencies on glibc and gcc
        sed "/ *libpth =>/c    libpth => ' '," \
          -i "$out"/lib/perl5/*/*/Config.pm
        # TODO: removing those paths would be cleaner than overwriting with nonsense.
        substituteInPlace "$out"/lib/perl5/*/*/Config_heavy.pl \
          --replace "${libcInc}" /no-such-path \
          --replace "${
              if stdenv.cc.cc or null != null then stdenv.cc.cc else "/no-such-path"
            }" /no-such-path \
          --replace "$man" /no-such-path
      ''; # */

    meta = {
      homepage = https://www.perl.org/;
      description = "The standard implementation of the Perl 5 programmming language";
      maintainers = [ maintainers.eelco ];
      platforms = platforms.all;
    };
  } // stdenv.lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) rec {
    crossVersion = "1.1.8";

    perl-cross-src = fetchurlBoot {
      url = "https://github.com/arsv/perl-cross/releases/download/${crossVersion}/perl-cross-${crossVersion}.tar.gz";
      sha256 = "072j491rpz2qx2sngbg4flqh4lx5865zyql7b9lqm6s1kknjdrh8";
    };

    # Hacky! But not sure how else we can access a native-targeted gcc6
    # https://github.com/arsv/perl-cross/issues/60
    nativeBuildInputs = [ buildPackages.buildPackages.gcc6 ];

    postUnpack = ''
      unpackFile ${perl-cross-src}
      cp -R perl-cross-${crossVersion}/* perl-${version}/
    '';

    configurePlatforms = [ "build" "host" "target" ];
  });
in rec {
  perl = perl524;

  perl522 = common {
    version = "5.22.4";
    sha256 = "1yk1xn4wmnrf2ph02j28khqarpyr24qwysjzkjnjv7vh5dygb7ms";
  };

  perl524 = common {
    version = "5.24.3";
    sha256 = "1m2px85kq2fyp2d4rx3bw9kg3car67qfqwrs5vlv96dx0x8rl06b";
  };

  perl526 = common {
    version = "5.26.1";
    sha256 = "1p81wwvr5jb81m41d07kfywk5gvbk0axdrnvhc2aghcdbr4alqz7";
  };
}
