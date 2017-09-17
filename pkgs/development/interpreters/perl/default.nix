{ lib, stdenv, fetchurlBoot, enableThreading ? stdenv ? glibc }:

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
  common = { version, sha256 }: stdenv.mkDerivation rec {
    name = "perl-${version}";

    src = fetchurlBoot {
      url = "mirror://cpan/src/5.0/${name}.tar.gz";
      inherit sha256;
    };

    # TODO: Add a "dev" output containing the header files.
    outputs = [ "out" "man" "devdoc" ];
    setOutputFlags = false;

    patches =
      [ # Do not look in /usr etc. for dependencies.
        ./no-sys-dirs.patch
      ]
      ++ optional stdenv.isSunOS ./ld-shared.patch
      ++ optional stdenv.isDarwin ./cpp-precomp.patch
      ++ optional (stdenv.isDarwin && versionAtLeast version "5.24") ./sw_vers.patch;

    postPatch = ''
      pwd="$(type -P pwd)"
      substituteInPlace dist/PathTools/Cwd.pm \
        --replace "/bin/pwd" "$pwd"
    '';
    sandboxProfile = sandbox.allow "ipc-sysv-sem";

    # Build a thread-safe Perl with a dynamic libperls.o.  We need the
    # "installstyle" option to ensure that modules are put under
    # $out/lib/perl5 - this is the general default, but because $out
    # contains the string "perl", Configure would select $out/lib.
    # Miniperl needs -lm. perl needs -lrt.
    configureFlags =
      [ "-de"
        "-Dcc=cc"
        "-Uinstallusrbinperl"
        "-Dinstallstyle=lib/perl5"
        "-Duseshrplib"
        "-Dlocincpth=${libcInc}/include"
        "-Dloclibpth=${libcLib}/lib"
      ]
      ++ optional stdenv.isSunOS "-Dcc=gcc"
      ++ optional enableThreading "-Dusethreads";

    configureScript = "${stdenv.shell} ./Configure";

    dontAddPrefix = true;

    enableParallelBuilding = true;

    preConfigure =
      ''
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
  };

in rec {

  perl = perl524;

  perl522 = common {
    version = "5.22.4";
    sha256 = "1yk1xn4wmnrf2ph02j28khqarpyr24qwysjzkjnjv7vh5dygb7ms";
  };

  perl524 = common {
    version = "5.24.2";
    sha256 = "1x4yj814a79lcarwb3ab6bbcb36hvb5n4ph4zg3yb0nabsjfi6v0";
  };

}
