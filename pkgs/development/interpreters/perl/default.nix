{ lib, stdenv, fetchurlBoot, buildPackages
, enableThreading ? stdenv ? glibc, makeWrapper
}:

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
    inherit version;

    name = "perl-${version}";

    src = fetchurlBoot {
      url = "mirror://cpan/src/5.0/${name}.tar.gz";
      inherit sha256;
    };

    # TODO: Add a "dev" output containing the header files.
    outputs = [ "out" "man" "devdoc" ] ++
      stdenv.lib.optional crossCompiling "dev";
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
      ++ optional (stdenv.isDarwin && versionAtLeast version "5.24") ./sw_vers.patch
      ++ optional crossCompiling ./MakeMaker-cross.patch;

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
      '' + optionalString (stdenv.isAarch32 || stdenv.isMips) ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      '' + optionalString stdenv.isDarwin ''
        substituteInPlace hints/darwin.sh --replace "env MACOSX_DEPLOYMENT_TARGET=10.3" ""
      '' + optionalString (!enableThreading) ''
        # We need to do this because the bootstrap doesn't have a static libpthread
        sed -i 's,\(libswanted.*\)pthread,\1,g' Configure
      '';

    setupHook = ./setup-hook.sh;

    passthru.libPrefix = "lib/perl5/site_perl";

    doCheck = false; # some tests fail, expensive

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
      '' + stdenv.lib.optionalString crossCompiling
      ''
        mkdir -p $dev/lib/perl5/cross_perl/${version}
        for dir in cnf/{stub,cpan}; do
          cp -r $dir/* $dev/lib/perl5/cross_perl/${version}
        done

        mkdir -p $dev/bin
        install -m755 miniperl $dev/bin/perl

        export runtimeArch="$(ls $out/lib/perl5/site_perl/${version})"
        # wrapProgram should use a runtime-native SHELL by default, but
        # it actually uses a buildtime-native one. If we ever fix that,
        # we'll need to fix this to use a buildtime-native one.
        #
        # Adding the arch-specific directory is morally incorrect, as
        # miniperl can't load the native modules there. However, it can
        # (and sometimes needs to) load and run some of the pure perl
        # code there, so we add it anyway. When needed, stubs can be put
        # into $dev/lib/perl5/cross_perl/${version}.
        wrapProgram $dev/bin/perl --prefix PERL5LIB : \
          "$dev/lib/perl5/cross_perl/${version}:$out/lib/perl5/${version}:$out/lib/perl5/${version}/$runtimeArch"
      ''; # */

    meta = {
      homepage = https://www.perl.org/;
      description = "The standard implementation of the Perl 5 programmming language";
      license = licenses.artistic1;
      maintainers = [ maintainers.eelco ];
      platforms = platforms.all;
    };
  } // stdenv.lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) rec {
    crossVersion = "1.2";

    perl-cross-src = fetchurlBoot {
      url = "https://github.com/arsv/perl-cross/releases/download/${crossVersion}/perl-cross-${crossVersion}.tar.gz";
      sha256 = "02cic7lk91hgmsg8klkm2kv88m2a8y22m4m8gl4ydxbap2z7g42r";
    };

    depsBuildBuild = [ buildPackages.stdenv.cc makeWrapper ];

    postUnpack = ''
      unpackFile ${perl-cross-src}
      cp -R perl-cross-${crossVersion}/* perl-${version}/
    '';

    configurePlatforms = [ "build" "host" "target" ];

    # TODO merge setup hooks
    setupHook = ./setup-hook-cross.sh;
  });
in rec {
  perl522 = common {
    version = "5.22.4";
    sha256 = "1yk1xn4wmnrf2ph02j28khqarpyr24qwysjzkjnjv7vh5dygb7ms";
  };

  perl524 = common {
    version = "5.24.4";
    sha256 = "0w0r6v5k5hw5q1k3p4c7krcxidkj2qzsj5dlrlrxhm01n7fksbxz";
  };

  perl526 = common {
    version = "5.26.2";
    sha256 = "03gpnxx1g6hvlh0v4aqx00580h787sfywp1vlvw64q2xcbm9qbsp";
  };

  perl528 = common {
    version = "5.28.0";
    sha256 = "1a3f822lcl8dr8v0hk80yyhpzqlljg49z9flb48rs3nbsij9z4ky";
  };
}
