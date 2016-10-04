{ stdenv, fetchFromRepoOrCz, perl, texinfo }:

assert (stdenv.isGlibc);

with stdenv.lib;

let
  date = "20160525";
  version = "0.9.27pre-${date}";
  rev = "1ca685f887310b5cbdc415cdfc3a578dbc8d82d8";
  sha256 = "149s847jkg2zdmk09h0cp0q69m8kxxci441zyw8b08fy9b87ayd8";
in

stdenv.mkDerivation rec {
  name = "tcc-${version}";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    inherit rev;
    inherit sha256;
  };

  outputs = [ "bin" "dev" "out" ];

  nativeBuildInputs = [ perl texinfo ];

  hardeningDisable = [ "fortify" ];

  postPatch = ''
    substituteInPlace "texi2pod.pl" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  preConfigure = ''
    configureFlagsArray+=("--elfinterp=$(cat $NIX_CC/nix-support/dynamic-linker)")
    configureFlagsArray+=("--crtprefix=${stdenv.glibc.out}/lib")
    configureFlagsArray+=("--sysincludepaths=${stdenv.glibc.dev}/include:{B}/include")
    configureFlagsArray+=("--libpaths=${stdenv.glibc.out}/lib")
  '';

  doCheck = true;
  checkTarget = "test";

  postFixup = ''
    paxmark m $bin/bin/tcc
  '';

  meta = {
    description = "Small, fast, and embeddable C compiler and interpreter";

    longDescription = ''
      TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike
      other C compilers, it is meant to be self-sufficient: you do not
      need an external assembler or linker because TCC does that for
      you.

      TCC compiles so fast that even for big projects Makefiles may not
      be necessary.

      TCC not only supports ANSI C, but also most of the new ISO C99
      standard and many GNU C extensions.

      TCC can also be used to make C scripts, i.e. pieces of C source
      that you run as a Perl or Python script.  Compilation is so fast
      that your script will be as fast as if it was an executable.

      TCC can also automatically generate memory and bound checks while
      allowing all C pointers operations.  TCC can do these checks even
      if non patched libraries are used.

      With libtcc, you can use TCC as a backend for dynamic code
      generation.
    '';

    homepage = http://www.tinycc.org/;
    license = licenses.lgpl2Plus;

    platforms = platforms.unix;
    maintainers = [ maintainers.joachifm ];
  };
}
