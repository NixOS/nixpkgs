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
  name = "perl-5.20.2";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SH/SHAY/${name}.tar.gz";
    sha256 = "17cvplgpxbm1hshxlkra2fldn4da1iap1lsnb04hdm8ply93k95i";
  };

  outputs = [ "out" "man" ];

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
      # Remove in 5.20.3
      ./perl-5.20.2-gcc5_fixes-1.patch
    ]
    ++ optional stdenv.isSunOS ./ld-shared.patch
    ++ stdenv.lib.optional stdenv.isDarwin [ ./cpp-precomp.patch ./no-libutil.patch ] ;

  # There's an annoying bug on sandboxed Darwin in Perl's Cwd.pm where it looks for pwd
  # in /bin/pwd and /usr/bin/pwd and then falls back on just "pwd" if it can't get them
  # while at the same time erasing the PATH environment variable so it unconditionally
  # fails. The code in question is guarded by a check for Mac OS, but the patch below
  # doesn't have any runtime effect on other platforms.
  postPatch = stdenv.lib.optional (stdenv.isDarwin && !stdenv.cc.nativeLibc) ''
    pwd="$(type -P pwd)"
    substituteInPlace dist/PathTools/Cwd.pm \
      --replace "pwd_cmd = 'pwd'" "pwd_cmd = '$pwd'"
  '';

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
    '';

  preBuild = optionalString (!(stdenv ? cc && stdenv.cc.nativeTools))
    ''
      # Make Cwd work on NixOS (where we don't have a /bin/pwd).
      substituteInPlace dist/PathTools/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
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
