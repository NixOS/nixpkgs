{ stdenv, fetchurl, enableThreading ? stdenv ? glibc }:

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

in

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "perl-5.20.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
    sha256 = "0jlvpd5l5nk7lzfd4akdg1sw6vinbkj6izclyyr0lrbidfky691m";
  };

  outputs = [ "out" "man" ];

  # FIXME needs gcc 4.9 in bootstrap tools
  hardening_stackprotector = false;

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
    ]
    ++ optional stdenv.isSunOS ./ld-shared.patch
    ++ stdenv.lib.optional stdenv.isDarwin [ ./cpp-precomp.patch ];

  # There's an annoying bug on sandboxed Darwin in Perl's Cwd.pm where it looks for pwd
  # in /bin/pwd and /usr/bin/pwd and then falls back on just "pwd" if it can't get them
  # while at the same time erasing the PATH environment variable so it unconditionally
  # fails. The code in question is guarded by a check for Mac OS, but the patch below
  # doesn't have any runtime effect on other platforms.
  postPatch = stdenv.lib.optional stdenv.isDarwin ''
    pwd="$(type -P pwd)"
    substituteInPlace dist/PathTools/Cwd.pm \
      --replace "/bin/pwd" "$pwd"
  '';

  sandboxProfile = stdenv.lib.sandbox.allow "ipc-sysv-sem";

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
      "-Dlocincpth=${libc}/include"
      "-Dloclibpth=${libc}/lib"
    ]
    ++ optional stdenv.isSunOS "-Dcc=gcc"
    ++ optional enableThreading "-Dusethreads";

  configureScript = "${stdenv.shell} ./Configure";

  dontAddPrefix = true;

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

      ${optionalString stdenv.isArm ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      ''}
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

  # Inspired by nuke-references, which I can't depend on because it uses perl. Perhaps it should just use sed :)
  postInstall = ''
    self=$(echo $out | sed -n "s|^$NIX_STORE/\\([a-z0-9]\{32\}\\)-.*|\1|p")

    sed -i "/$self/b; s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" "$out"/lib/perl5/*/*/Config.pm
    sed -i "/$self/b; s|$NIX_STORE/[a-z0-9]\{32\}-|$NIX_STORE/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-|g" "$out"/lib/perl5/*/*/Config_heavy.pl
  '';

  setupHook = ./setup-hook.sh;

  passthru.libPrefix = "lib/perl5/site_perl";

  meta = {
    homepage = https://www.perl.org/;
    description = "The standard implementation of the Perl 5 programmming language";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
