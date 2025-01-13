{
  lib,
  copyPkgconfigItems,
  fetchFromRepoOrCz,
  makePkgconfigItem,
  perl,
  stdenv,
  texinfo,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tcc";
  version = "0.9.27-unstable-2022-07-15";

  src = fetchFromRepoOrCz {
    repo = "tinycc";
    rev = "af1abf1f45d45b34f0b02437f559f4dfdba7d23c";
    hash = "sha256-jY0P2GErmo//YBaz6u4/jj/voOE3C2JaIDRmo0orXN8=";
  };

  outputs = [
    "out"
    "info"
    "man"
  ];

  nativeBuildInputs = [
    copyPkgconfigItems
    perl
    texinfo
    which
  ];

  strictDeps = true;

  pkgconfigItems =
    let
      libtcc-pcitem = {
        name = "libtcc";
        inherit (finalAttrs) version;
        cflags = [ "-I${libtcc-pcitem.variables.includedir}" ];
        libs = [
          "-L${libtcc-pcitem.variables.libdir}"
          "-Wl,--rpath ${libtcc-pcitem.variables.libdir}"
          "-ltcc"
        ];
        variables = {
          prefix = "${placeholder "out"}";
          includedir = "${placeholder "dev"}/include";
          libdir = "${placeholder "lib"}/lib";
        };
        description = "Tiny C compiler backend";
      };
    in
    [
      (makePkgconfigItem libtcc-pcitem)
    ];

  postPatch = ''
    patchShebangs texi2pod.pl
  '';

  configureFlags =
    [
      "--cc=$CC"
      "--ar=$AR"
      "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
      "--sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include"
      "--libpaths=${lib.getLib stdenv.cc.libc}/lib"
      # build cross compilers
      "--enable-cross"
    ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [
      "--config-musl"
    ];

  preConfigure =
    let
      # To avoid "malformed 32-bit x.y.z" error on mac when using clang
      versionIsClean = version: builtins.match "^[0-9]\\.+[0-9]+\\.[0-9]+" version != null;
    in
    ''
      ${
        if stdenv.hostPlatform.isDarwin && !versionIsClean finalAttrs.version then
          "echo 'not overwriting VERSION since it would upset ld'"
        else
          "echo ${finalAttrs.version} > VERSION"
      }
      configureFlagsArray+=("--elfinterp=$(< $NIX_CC/nix-support/dynamic-linker)")
    '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-error=implicit-int"
      "-Wno-error=int-conversion"
    ]
  );

  # Test segfault for static build
  doCheck = !stdenv.hostPlatform.isStatic;

  checkTarget = "test";
  # https://www.mail-archive.com/tinycc-devel@nongnu.org/msg10142.html
  preCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    rm tests/tests2/{108,114}*
  '';

  meta = {
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
    license = with lib.licenses; [ lgpl21Only ];
    mainProgram = "tcc";
    maintainers = with lib.maintainers; [
      joachifm
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
    # https://www.mail-archive.com/tinycc-devel@nongnu.org/msg10199.html
    broken = stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64;
  };
})
# TODO: more multiple outputs
# TODO: self-compilation
