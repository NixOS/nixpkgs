{ stdenv, fetchurl, enableThreading ? true }:

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

  libc = if stdenv.gcc.libc or null != null then stdenv.gcc.libc else "/usr";

in

with {
  inherit (stdenv.lib) optional optionalString;
};

stdenv.mkDerivation rec {
  name = "perl-5.16.3";

  src = fetchurl {
    url = "mirror://cpan/src/${name}.tar.gz";
    sha256 = "1dpd9lhc4723wmsn4dsn4m320qlqgyw28bvcbhnfqp2nl3f0ikv9";
  };

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
      ./no-impure-config-time.patch
      ./fixed-man-page-date.patch
      ./no-date-in-perl-binary.patch
    ]
    ++ optional stdenv.isSunOS  ./ld-shared.patch
    ++ stdenv.lib.optional stdenv.isDarwin [ ./cpp-precomp.patch ./no-libutil.patch ] ;

  # Build a thread-safe Perl with a dynamic libperls.o.  We need the
  # "installstyle" option to ensure that modules are put under
  # $out/lib/perl5 - this is the general default, but because $out
  # contains the string "perl", Configure would select $out/lib.
  # Miniperl needs -lm. perl needs -lrt.
  configureFlags =
    [ "-de"
      "-Dcc=gcc"
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

      ${optionalString stdenv.isCygwin ''
        cp cygwin/cygwin.c{,.bak}
        echo "#define PERLIO_NOT_STDIO 0" > tmp
        cat tmp cygwin/cygwin.c.bak > cygwin/cygwin.c
      ''}
    '';

  preBuild = optionalString (!(stdenv ? gcc && stdenv.gcc.nativeTools))
    ''
      # Make Cwd work on NixOS (where we don't have a /bin/pwd).
      substituteInPlace dist/Cwd/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
    '';

  setupHook = ./setup-hook.sh;

  passthru.libPrefix = "lib/perl5/site_perl";
}
