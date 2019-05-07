{ config, lib, stdenv, fetchurl, buildPackages, callPackage
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

  common = { self, version, sha256 }: stdenv.mkDerivation (rec {
    inherit version;

    name = "perl-${version}";

    src = fetchurl {
      url = "mirror://cpan/src/5.0/${name}.tar.gz";
      inherit sha256;
    };

    # TODO: Add a "dev" output containing the header files.
    outputs = [ "out" "man" "devdoc" ] ++
      stdenv.lib.optional crossCompiling "dev";
    setOutputFlags = false;

    disallowedReferences = [ stdenv.cc ];

    patches =
      [
        # Do not look in /usr etc. for dependencies.
        (if (versionOlder version "5.29.6") then ./no-sys-dirs-5.26.patch else ./no-sys-dirs-5.29.patch)
      ]
      ++ optional (versionOlder version "5.29.6")
        # Fix parallel building: https://rt.perl.org/Public/Bug/Display.html?id=132360
        (fetchurl {
          url = "https://rt.perl.org/Public/Ticket/Attachment/1502646/807252/0001-Fix-missing-build-dependency-for-pods.patch";
          sha256 = "1bb4mldfp8kq1scv480wm64n2jdsqa3ar46cjp1mjpby8h5dr2r0";
        })
      ++ optional stdenv.isSunOS ./ld-shared.patch
      ++ optionals stdenv.isDarwin [ ./cpp-precomp.patch ./sw_vers.patch ]
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
      ++ optionals ((builtins.match ''5\.[0-9]*[13579]\..+'' version) != null) [ "-Dusedevel" "-Uversiononly" ]
      ++ optional stdenv.isSunOS "-Dcc=gcc"
      ++ optional enableThreading "-Dusethreads";

    configureScript = stdenv.lib.optionalString (!crossCompiling) "${stdenv.shell} ./Configure";

    dontAddPrefix = !crossCompiling;

    enableParallelBuilding = !crossCompiling;

    preConfigure = ''
        substituteInPlace ./Configure --replace '`LC_ALL=C; LANGUAGE=C; export LC_ALL; export LANGUAGE; $date 2>&1`' 'Thu Jan  1 00:00:01 UTC 1970'
        substituteInPlace ./Configure --replace '$uname -a' '$uname --kernel-name --machine --operating-system'
      '' + optionalString (!crossCompiling) ''
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

    passthru = rec {
      interpreter = "${self}/bin/perl";
      libPrefix = "lib/perl5/site_perl";
      pkgs = callPackage ../../../top-level/perl-packages.nix {
        perl = self;
        overrides = config.perlPackageOverrides or (p: {}); # TODO: (self: super: {}) like in python
      };
      buildEnv = callPackage ./wrapper.nix {
        perl = self;
        inherit (pkgs) requiredPerlModules;
      };
      withPackages = f: buildEnv.override { extraLibs = f pkgs; };
    };

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
          --replace "${stdenv.cc}" /no-such-path \
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
      priority = 6; # in `buildEnv' (including the one inside `perl.withPackages') the library files will have priority over files in `perl`
    };
  } // stdenv.lib.optionalAttrs (stdenv.buildPlatform != stdenv.hostPlatform) rec {
    crossVersion = "9e4051cd28b7b3afb162776f5627c7abe4c7b9ea"; # Apr 21, 2019

    perl-cross-src = fetchurl {
      url = "https://github.com/arsv/perl-cross/archive/${crossVersion}.tar.gz";
      sha256 = "0dj99w2dicbp3c3wn0k32785pc4c68iqnlyxswnza6mhw6wvl9v7";
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
  # the latest Maint version
  perl528 = common {
    self = perl528;
    version = "5.28.2";
    sha256 = "1iynpsxdym4h76kgndmn3ykvwxhqz444xvaz8z2irsxkvmnlb5da";
  };

  # the latest Devel version
  perldevel = common {
    self = perldevel;
    version = "5.29.9";
    sha256 = "017x3nghyc5m8q1yqnrdma96b3d5rlfx87vv5mi64jq0r8k6zppm";
  };
}
