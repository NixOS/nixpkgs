{ stdenv, lib, fetchFromRepoOrCz, perl, texinfo }:
with lib;

stdenv.mkDerivation rec {
  pname = "tcc";
  version = "0.9.27";
  upstreamVersion = "release_${concatStringsSep "_" (builtins.splitVersion version)}";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    rev = upstreamVersion;
    sha256 = "12mm1lqywz0akr2yb2axjfbw8lwv57nh395vzsk534riz03ml977";
  };

  nativeBuildInputs = [ perl texinfo ];

  hardeningDisable = [ "fortify" ];

  enableParallelBuilding = true;

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

  postFixup = ''
    cat >libtcc.pc <<EOF
    Name: libtcc
    Description: Tiny C compiler backend
    Version: ${version}
    Libs: -L$out/lib -Wl,--rpath $out/lib -ltcc -ldl
    Cflags: -I$out/include
    EOF
    install -Dt $out/lib/pkgconfig libtcc.pc -m 444
  '';

  doCheck = true;
  checkTarget = "test";

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

    homepage = "http://www.tinycc.org/";
    license = licenses.mit;

    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.joachifm ];
  };
}
