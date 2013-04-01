{ stdenv, fetchurl }:

let

  libc = if stdenv.gcc.libc or null != null then stdenv.gcc.libc else "/usr";

in

stdenv.mkDerivation rec {
  name = "perl-5.16.2";

  src = fetchurl {
    url = "mirror://cpan/src/${name}.tar.gz";
    sha256 = "03nh8bqnjsdd5izjv3n2yfcxw4ck0llwww36jpbjbjgixwpqpy4f";
  };

  patches =
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
    ]
    ++ stdenv.lib.optional stdenv.isSunOS  ./ld-shared.patch
    ++ stdenv.lib.optional stdenv.isDarwin ./no-libutil.patch;

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
    ++ stdenv.lib.optional (stdenv ? glibc) "-Dusethreads";

  configureScript = "${stdenv.shell} ./Configure";

  dontAddPrefix = true;

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

      ${stdenv.lib.optionalString stdenv.isArm ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      ''}
    '';

  preBuild = stdenv.lib.optionalString (!(stdenv ? gcc && stdenv.gcc.nativeTools))
    ''
      # Make Cwd work on NixOS (where we don't have a /bin/pwd).
      substituteInPlace dist/Cwd/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
    '';

  setupHook = ./setup-hook.sh;

  doCheck = true;
  # some network-related tests don't work, mostly probably due to our sandboxing
  testsToSkip = ''
    lib/Net/hostent.t \
    dist/IO/t/{io_multihomed.t,io_sock.t} \
    t/porting/{maintainers.t,regen.t} \
    cpan/Socket/t/getnameinfo.t
  '';
  postPatch = ''
    for test in ${testsToSkip}; do
      rm "$test"
      pat=`echo "$test" | sed 's,/,\\\\/,g'` # just escape slashes
      sed "/^$pat/d" -i MANIFEST
    done
  '';

  passthru.libPrefix = "lib/perl5/site_perl";
}
