{ stdenv, fetchurl, perl, texinfo }:

assert stdenv ? glibc;

let version = "0.9.25"; in
  stdenv.mkDerivation {
    name = "tinycc-${version}";

    src = fetchurl {
      url = "mirror://savannah/tinycc/tcc-${version}.tar.bz2";
      sha256 = "0dfycf80x73dz67c97j1ry29wrv35393ai5ry46i1x1fzfq6rv8v";
    };

    buildNativeInputs = [ perl texinfo ];

    patches =
      [ (fetchurl {
           # Add support for `alloca' on x86-64.
           url = "http://repo.or.cz/w/tinycc.git/patch/8ea8305199496ba29b6d0da2de07aea4441844aa";
           sha256 = "0dz1cm9zihk533hszqql4gxpzbp8c4g9dnvkkh9vs4js6fnz1fl2";
           name = "x86-64-alloca.patch";
         })

        (fetchurl {
           # Fix alignment of the return value of `alloca'.
           url = "http://repo.or.cz/w/tinycc.git/patch/dca2b15df42c1341794dd412917708416da25594";
           sha256 = "0617a69gnfdmv8pr6dj3szv97v3zh57439dsbklxrnipx2jv6pq7";
           name = "x86-64-alloca-align.patch";
         })
      ];

    postPatch = ''
      substituteInPlace "texi2pod.pl" \
        --replace "/usr/bin/perl" "${perl}/bin/perl"

      # To produce executables, `tcc' needs to know where `crt*.o' are.
      sed -i "tcc.h" \
        -e's|define CONFIG_TCC_CRT_PREFIX.*$|define CONFIG_TCC_CRT_PREFIX "${stdenv.glibc}/lib"|g'

      sed -i "libtcc.c" \
        -e's|tcc_add_library_path(s, CONFIG_SYSROOT "/lib");|tcc_add_library_path(s, "${stdenv.glibc}/lib");|g;
           s|tcc_add_sysinclude_path(s, CONFIG_SYSROOT "/usr/include");|tcc_add_library_path(s, "${stdenv.glibc}/include");|g ;
           s|tcc_add_sysinclude_path(s, buf);|tcc_add_sysinclude_path(s, buf); tcc_add_sysinclude_path(s, "${stdenv.glibc}/include");|g'

      # Tell it about the loader's location.
      sed -i "tccelf.c" \
        -e's|".*/ld-linux\([^"]\+\)"|"${stdenv.glibc}/lib/ld-linux\1"|g'
    ''; # "

    postInstall = ''
      makeinfo --force tcc-doc.texi || true

      mkdir -p "$out/share/info"
      mv tcc-doc.info* "$out/share/info"

      echo 'int main () { printf ("it works!\n"); exit(0); }' | \
         "$out/bin/tcc" -run -
    '';

    doCheck = true;
    checkTarget = "test";

    meta = {
      description = "TinyCC, a small, fast, and embeddable C compiler and interpreter";

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
      license = "LGPLv2+";

      platforms = stdenv.lib.platforms.unix;
      maintainers = [ stdenv.lib.maintainers.ludo ];
    };
  }
