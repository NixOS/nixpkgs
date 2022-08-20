{ lib
, stdenv
, fetchFromRepoOrCz
, copyPkgconfigItems
, makePkgconfigItem
, perl
, texinfo
, which
}:

stdenv.mkDerivation rec {
  pname = "tcc";
  version = "unstable-2022-07-15";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    rev = "af1abf1f45d45b34f0b02437f559f4dfdba7d23c";
    hash = "sha256-jY0P2GErmo//YBaz6u4/jj/voOE3C2JaIDRmo0orXN8=";
  };

  nativeBuildInputs = [
    copyPkgconfigItems
    perl
    texinfo
    which
  ];

  pkgconfigItems = [
    (makePkgconfigItem rec {
      name = "libtcc";
      inherit version;
      cflags = [ "-I${variables.includedir}" ];
      libs = [
        "-L${variables.libdir}"
        "-Wl,--rpath ${variables.libdir}"
        "-ltcc"
        "-ldl"
      ];
      variables = rec {
        prefix = "${placeholder "out"}";
        includedir = "${prefix}/include";
        libdir = "${prefix}/lib";
      };
      description = "Tiny C compiler backend";
    })
  ];

  postPatch = ''
    patchShebangs texi2pod.pl
  '';

  configureFlags = [
    "--cc=$CC"
    "--ar=$AR"
    "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
    "--sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include"
    "--libpaths=${lib.getLib stdenv.cc.libc}/lib"
    # build cross compilers
    "--enable-cross"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    "--config-musl"
  ];

  preConfigure = ''
    echo ${version} > VERSION
    configureFlagsArray+=("--elfinterp=$(< $NIX_CC/nix-support/dynamic-linker)")
  '';

  outputs = [ "out" "info" "man" ];

  doCheck = true;
  checkTarget = "test";

  meta = with lib; {
    homepage = "https://repo.or.cz/tinycc.git";
    description = "Small, fast, and embeddable C compiler and interpreter";
    longDescription = ''
      TinyCC (aka TCC) is a small but hyper fast C compiler.  Unlike other C
      compilers, it is meant to be self-sufficient: you do not need an external
      assembler or linker because TCC does that for you.

      TCC compiles so fast that even for big projects Makefiles may not be
      necessary.

      TCC not only supports ANSI C, but also most of the new ISO C99 standard
      and many GNU C extensions.

      TCC can also be used to make C scripts, i.e. pieces of C source that you
      run as a Perl or Python script.  Compilation is so fast that your script
      will be as fast as if it was an executable.

      TCC can also automatically generate memory and bound checks while allowing
      all C pointers operations.  TCC can do these checks even if non patched
      libraries are used.

      With libtcc, you can use TCC as a backend for dynamic code generation.
    '';
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ joachifm AndersonTorres ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin;
  };
}
# TODO: more multiple outputs
# TODO: self-compilation
# TODO: provide expression for stable release
