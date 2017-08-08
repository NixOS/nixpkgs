{ stdenv, fetchurl, fetchgit, fetchzip, file, python2, tzdata, procps
, llvm, jemalloc, ncurses, darwin, binutils, rustPlatform, git, cmake, curl
, which, libffi, gdb
, version
, forceBundledLLVM ? false
, src
, configureFlags ? []
, patches
, targets
, targetPatches
, targetToolchains
, doCheck ? true
, buildPlatform, hostPlatform
} @ args:

let
  inherit (stdenv.lib) optional optionalString;

  procps = if stdenv.isDarwin then darwin.ps else args.procps;

  llvmShared = llvm.override { enableSharedLibraries = true; };

  target = builtins.replaceStrings [" "] [","] (builtins.toString targets);

in

stdenv.mkDerivation {
  name = "rustc-${version}";
  inherit version;

  inherit src;

  __impureHostDeps = [ "/usr/lib/libedit.3.dylib" ];

  NIX_LDFLAGS = optionalString stdenv.isDarwin "-rpath ${llvmShared}/lib";

  # Enable nightly features in stable compiles (used for
  # bootstrapping, see https://github.com/rust-lang/rust/pull/37265).
  # This loosens the hard restrictions on bootstrapping-compiler
  # versions.
  RUSTC_BOOTSTRAP = "1";

  # Increase codegen units to introduce parallelism within the compiler.
  RUSTFLAGS = "-Ccodegen-units=10";

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  configureFlags = configureFlags
                ++ [ "--enable-local-rust" "--local-rust-root=${rustPlatform.rust.rustc}" "--enable-rpath" ]
                ++ [ "--enable-vendor" "--disable-locked-deps" ]
                ++ [ "--enable-llvm-link-shared" ]
                # ++ [ "--jemalloc-root=${jemalloc}/lib"
                ++ [ "--default-linker=${stdenv.cc}/bin/cc" "--default-ar=${binutils.out}/bin/ar" ]
                ++ optional (stdenv.cc.cc ? isClang) "--enable-clang"
                ++ optional (targets != []) "--target=${target}"
                ++ optional (!forceBundledLLVM) "--llvm-root=${llvmShared}";

  patches = patches ++ targetPatches;

  passthru.target = target;

  postPatch = ''
    # Fix dynamic linking against llvm
    #${optionalString (!forceBundledLLVM) ''sed -i 's/, kind = \\"static\\"//g' src/etc/mklldeps.py''}

    # Fix the configure script to not require curl as we won't use it
    sed -i configure \
      -e '/probe_need CFG_CURL curl/d'

    # Fix the use of jemalloc prefixes which our jemalloc doesn't have
    # TODO: reenable if we can figure out how to get our jemalloc to work
    #[ -f src/liballoc_jemalloc/lib.rs ] && sed -i 's,je_,,g' src/liballoc_jemalloc/lib.rs
    #[ -f src/liballoc/heap.rs ] && sed -i 's,je_,,g' src/liballoc/heap.rs # Remove for 1.4.0+

    # Disable fragile linker-output-non-utf8 test
    rm -vr src/test/run-make/linker-output-non-utf8 || true

    # Remove test targeted at LLVM 3.9 - https://github.com/rust-lang/rust/issues/36835
    rm -vr src/test/run-pass/issue-36023.rs || true

    # Disable test getting stuck on hydra - possible fix:
    # https://reviews.llvm.org/rL281650
    rm -vr src/test/run-pass/issue-36474.rs || true

    # Disable some failing gdb tests. Try re-enabling these when gdb
    # is updated past version 7.12.
    rm src/test/debuginfo/basic-types-globals.rs
    rm src/test/debuginfo/basic-types-mut-globals.rs
    rm src/test/debuginfo/c-style-enum.rs
    rm src/test/debuginfo/lexical-scopes-in-block-expression.rs
    rm src/test/debuginfo/limited-debuginfo.rs
    rm src/test/debuginfo/simple-struct.rs
    rm src/test/debuginfo/simple-tuple.rs
    rm src/test/debuginfo/union-smoke.rs
    rm src/test/debuginfo/vec-slices.rs
    rm src/test/debuginfo/vec.rs

    # Useful debugging parameter
    # export VERBOSE=1
  ''
  + optionalString stdenv.isDarwin ''
    # Disable all lldb tests.
    # error: Can't run LLDB test because LLDB's python path is not set
    rm -vr src/test/debuginfo/*
  '';

  preConfigure = ''
    # Needed flags as the upstream configure script has a broken prefix substitution
    configureFlagsArray+=("--datadir=$out/share")
    configureFlagsArray+=("--infodir=$out/share/info")
  '';

  # rustc unfortunately need cmake for compiling llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  # ps is needed for one of the test cases
  nativeBuildInputs =
    [ file python2 procps rustPlatform.rust.rustc git cmake
      which libffi
    ]
    # Only needed for the debuginfo tests
    ++ optional (!stdenv.isDarwin) gdb;

  buildInputs = [ ncurses ] ++ targetToolchains
    ++ optional (!forceBundledLLVM) llvmShared;

  outputs = [ "out" "doc" ];
  setOutputFlags = false;

  # Disable codegen units for the tests.
  preCheck = ''
    export RUSTFLAGS=
    export TZDIR=${tzdata}/share/zoneinfo
  '' +
  # Ensure TMPDIR is set, and disable a test that removing the HOME
  # variable from the environment falls back to another home
  # directory.
  optionalString stdenv.isDarwin ''
    export TMPDIR=/tmp
    sed -i '28s/home_dir().is_some()/true/' ./src/test/run-pass/env-home-dir.rs
  '';

  inherit doCheck;

  configurePlatforms = [];

  # https://github.com/NixOS/nixpkgs/pull/21742#issuecomment-272305764
  # https://github.com/rust-lang/rust/issues/30181
  # enableParallelBuilding = false;

  meta = with stdenv.lib; {
    homepage = http://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan wizeman globin havvy wkennington ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
