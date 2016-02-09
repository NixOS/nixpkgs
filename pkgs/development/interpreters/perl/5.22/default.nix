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
  name = "perl-5.22.0";

  src = fetchurl {
    url = "mirror://cpan/src/5.0/${name}.tar.gz";
    sha256 = "0g5bl8sdpzx9gx2g5jq3py4bj07z2ylk7s1qn0fvsss2yl3hhs8c";
  };

  outputs = [ "out" "man" ];

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
    ]
    ++ optional stdenv.isSunOS ./ld-shared.patch
    ++ stdenv.lib.optional stdenv.isDarwin [ ./cpp-precomp.patch ];

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

  postPatch = ''
    pwd="$(type -P pwd)"
    substituteInPlace dist/PathTools/Cwd.pm \
      --replace "pwd_cmd = 'pwd'" "pwd_cmd = '$pwd'"
  '';

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

  setupHook = ./setup-hook.sh;

  passthru.libPrefix = "lib/perl5/site_perl";

  preCheck = ''
    # Try and setup a local hosts file
    if [ -f "${libc}/lib/libnss_files.so" ]; then
      mkdir $TMPDIR/fakelib
      cp "${libc}/lib/libnss_files.so" $TMPDIR/fakelib
      sed -i 's,/etc/hosts,/dev/fd/3,g' $TMPDIR/fakelib/libnss_files.so
      export LD_LIBRARY_PATH=$TMPDIR/fakelib
    fi
  '';

  postCheck = ''
    unset LD_LIBRARY_PATH
  '';

  meta = {
    homepage = https://www.perl.org/;
    description = "The standard implementation of the Perl 5 programmming language";
    maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
