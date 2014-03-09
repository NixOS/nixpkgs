{ stdenv, fetchurl }:

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
    ++ optional (stdenv ? glibc) "-Dusethreads";

  configureScript = "${stdenv.shell} ./Configure";

  dontAddPrefix = true;

  enableParallelBuilding = true;

  preConfigure =
    ''
      configureFlags="$configureFlags -Dprefix=$out -Dman1dir=$out/share/man/man1 -Dman3dir=$out/share/man/man3"

      ${optionalString stdenv.isArm ''
        configureFlagsArray=(-Dldflags="-lm -lrt")
      ''}
    '';

  preBuild = optionalString (!(stdenv ? gcc && stdenv.gcc.nativeTools))
    ''
      # Make Cwd work on NixOS (where we don't have a /bin/pwd).
      substituteInPlace dist/Cwd/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
    '';

  setupHook = ./setup-hook.sh;

  doCheck = !stdenv.isDarwin;

  # some network-related tests don't work, mostly probably due to our sandboxing
  testsToSkip = ''
    lib/Net/hostent.t \
    dist/IO/t/{io_multihomed.t,io_sock.t} \
    dist/Net-Ping/t/*.t \
    cpan/autodie/t/truncate.t \
    t/porting/{maintainers.t,regen.t} \
    cpan/Socket/t/get{name,addr}info.t \
  '' + optionalString stdenv.isFreeBSD ''
    cpan/CPANPLUS/t/04_CPANPLUS-Module.t \
    cpan/CPANPLUS/t/20_CPANPLUS-Dist-MM.t \
  '' + " ";

  postPatch = optionalString (!stdenv.isDarwin) /* this failed on Darwin, no idea why */ ''
    for test in ${testsToSkip}; do
      echo "Removing test" $test
      rm "$test"
      pat=`echo "$test" | sed 's,/,\\\\/,g'` # just escape slashes
      sed "/^$pat/d" -i MANIFEST
    done
  '';

  passthru.libPrefix = "lib/perl5/site_perl";
}
