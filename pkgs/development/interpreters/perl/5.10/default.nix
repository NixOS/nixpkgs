{ stdenv, fetchurl }:

let 
  
  libc = if stdenv ? gcc && stdenv.gcc.libc != null then stdenv.gcc.libc else "/usr";

in

stdenv.mkDerivation rec {
  name = "perl-5.10.1";

  src = fetchurl {
    url = "mirror://cpan/src/${name}.tar.gz";
    sha256 = "0dagnhjgmslfx1jawz986nvc3jh1klk7mn2l8djdca1b9gm2czyb";
  };

  patches = 
    [ # Do not look in /usr etc. for dependencies.
      ./no-sys-dirs.patch
    ];

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
      substituteInPlace lib/Cwd.pm --replace "'/bin/pwd'" "'$(type -tP pwd)'"
    '';

  setupHook = ./setup-hook.sh;
}
