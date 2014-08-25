{ stdenv, fetchurl, perl, texinfo }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  name = "tcc-0.9.26";

  src = fetchurl {
    url = "mirror://savannah/tinycc/${name}.tar.bz2";
    sha256 = "0wbdbdq6090ayw8bxnbikiv989kykff3m5rzbia05hrnwhd707jj";
  };

  nativeBuildInputs = [ perl texinfo ];

  postPatch = ''
    substituteInPlace "texi2pod.pl" \
      --replace "/usr/bin/perl" "${perl}/bin/perl"
  '';

  preConfigure = ''
    configureFlagsArray+=("--elfinterp=$(cat $NIX_GCC/nix-support/dynamic-linker)")
    configureFlagsArray+=("--crtprefix=${stdenv.glibc}/lib")
    configureFlagsArray+=("--sysincludepaths=${stdenv.glibc}/include:{B}/include")
    configureFlagsArray+=("--libpaths=${stdenv.glibc}/lib")
  '';

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "Small, fast, and embeddable C compiler and interpreter";

    longDescription =
      '' TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike
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
    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ ];
  };
}
