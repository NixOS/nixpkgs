{ stdenv, fetchFromRepoOrCz, perl, texinfo }:
with stdenv.lib;

let
  date = "20170710";
  version = "0.9.27pre-${date}";
  rev = "2acb04f7f2077a4cff103421d79ceee48441918a";
  sha256 = "1rh89dx1myqfm752d4rlzrm8aadfm17fm88ps0q9ibmbxavb45qw";
in

stdenv.mkDerivation rec {
  name = "tcc-${version}";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    inherit rev;
    inherit sha256;
  };

  nativeBuildInputs = [ perl texinfo ];

  hardeningDisable = [ "fortify" ];

  postPatch = ''
    substituteInPlace "texi2pod.pl" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  preConfigure = ''
    echo ${version} > VERSION

    configureFlagsArray+=("--cc=cc")
    configureFlagsArray+=("--elfinterp=$(< $NIX_CC/nix-support/dynamic-linker)")
    configureFlagsArray+=("--crtprefix=${getLib stdenv.cc.libc}/lib")
    configureFlagsArray+=("--sysincludepaths=${getDev stdenv.cc.libc}/include:{B}/include")
    configureFlagsArray+=("--libpaths=${getLib stdenv.cc.libc}/lib")
  '';

  doCheck = true;
  checkTarget = "test";

  postFixup = ''
    paxmark m $out/bin/tcc
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
    license = licenses.mit;

    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.joachifm ];
  };
}
