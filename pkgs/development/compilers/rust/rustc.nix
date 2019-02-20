{ stdenv, targetPackages, removeReferencesTo
, fetchurl, fetchgit, fetchzip, file, python2, tzdata, ps
, llvm, ncurses, darwin, rustPlatform, git, cmake, curl
, which, libffi, gdb
, version
, withBundledLLVM ? false
, src
, configureFlags ? []
, patches
, targets
, targetPatches
, targetToolchains
, doCheck ? true
, broken ? false
}:

let
  inherit (stdenv.lib) optional optionalString;
  inherit (darwin.apple_sdk.frameworks) Security;

  llvmShared = llvm.override { enableSharedLibraries = true; };

  target = builtins.replaceStrings [" "] [","] (builtins.toString targets);
in

stdenv.mkDerivation {
  name = "rustc-${version}";
  inherit version;

  inherit src;

  __darwinAllowLocalNetworking = true;

  # rustc complains about modified source files otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  # Running the default `strip -S` command on Darwin corrupts the
  # .rlib files in "lib/".
  #
  # See https://github.com/NixOS/nixpkgs/pull/34227
  stripDebugList = if stdenv.isDarwin then [ "bin" ] else null;

  NIX_LDFLAGS =
       # when linking stage1 libstd: cc: undefined reference to `__cxa_begin_catch'
       optional (stdenv.isLinux && !withBundledLLVM) "--push-state --as-needed -lstdc++ --pop-state"
    ++ optional (stdenv.isDarwin && !withBundledLLVM) "-lc++"
    ++ optional stdenv.isDarwin "-rpath ${llvmShared}/lib";

  # Enable nightly features in stable compiles (used for
  # bootstrapping, see https://github.com/rust-lang/rust/pull/37265).
  # This loosens the hard restrictions on bootstrapping-compiler
  # versions.
  RUSTC_BOOTSTRAP = "1";

  # Increase codegen units to introduce parallelism within the compiler.
  RUSTFLAGS = "-Ccodegen-units=10";

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  # Reference: https://github.com/rust-lang/rust/blob/master/src/bootstrap/configure.py
  configureFlags = configureFlags
                ++ [ "--enable-local-rust" "--local-rust-root=${rustPlatform.rust.rustc}" "--enable-rpath"
                     "--enable-vendor"
                     "--default-linker=${targetPackages.stdenv.cc}/bin/cc" ]
                ++ optional (!withBundledLLVM) [ "--enable-llvm-link-shared" "--llvm-root=${llvmShared}" ]
                ++ optional (targets != []) "--target=${target}";

  # The bootstrap.py will generated a Makefile that then executes the build.
  # The BOOTSTRAP_ARGS used by this Makefile must include all flags to pass
  # to the bootstrap builder.
  postConfigure = ''
    substituteInPlace Makefile --replace 'BOOTSTRAP_ARGS :=' 'BOOTSTRAP_ARGS := --jobs $(NIX_BUILD_CORES)'
  '';

  patches = patches ++ targetPatches;

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

  passthru.target = target;

  postPatch = ''
    patchShebangs src/etc

    ${optionalString (!withBundledLLVM) ''rm -rf src/llvm''}

    # Fix the configure script to not require curl as we won't use it
    sed -i configure \
      -e '/probe_need CFG_CURL curl/d'

    # On Hydra: `TcpListener::bind(&addr)`: Address already in use (os error 98)'
    sed '/^ *fn fast_rebind()/i#[ignore]' -i src/libstd/net/tcp.rs

    # https://github.com/rust-lang/rust/issues/39522
    echo removing gdb-version-sensitive tests...
    find src/test/debuginfo -type f -execdir grep -q ignore-gdb-version '{}' \; -print -delete
    rm src/test/debuginfo/{borrowed-c-style-enum.rs,c-style-enum-in-composite.rs,gdb-pretty-struct-and-enums.rs,generic-enum-with-different-disr-sizes.rs}

    # Useful debugging parameter
    # export VERBOSE=1
  '' + optionalString stdenv.isDarwin ''
    # Disable all lldb tests.
    # error: Can't run LLDB test because LLDB's python path is not set
    rm -vr src/test/debuginfo/*
    rm -v src/test/run-pass/backtrace-debuginfo.rs || true

    # error: No such file or directory
    rm -v src/test/ui/run-pass/issues/issue-45731.rs || true

    # Disable tests that fail when sandboxing is enabled.
    substituteInPlace src/libstd/sys/unix/ext/net.rs \
        --replace '#[test]' '#[test] #[ignore]'
    substituteInPlace src/test/run-pass/env-home-dir.rs \
        --replace 'home_dir().is_some()' true
    rm -v src/test/run-pass/fds-are-cloexec.rs || true  # FIXME: pipes?
    rm -v src/test/ui/run-pass/threads-sendsync/sync-send-in-std.rs || true  # FIXME: ???
  '';

  # rustc unfortunately need cmake for compiling llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  # ps is needed for one of the test cases
  nativeBuildInputs =
    [ file python2 ps rustPlatform.rust.rustc git cmake
      which libffi removeReferencesTo
    ]
    # Only needed for the debuginfo tests
    ++ optional (!stdenv.isDarwin) gdb;

  buildInputs = targetToolchains
    ++ optional stdenv.isDarwin Security
    ++ optional (!withBundledLLVM) llvmShared;

  outputs = [ "out" "man" "doc" ];
  setOutputFlags = false;

  # Disable codegen units and hardening for the tests.
  preCheck = ''
    export RUSTFLAGS=
    export TZDIR=${tzdata}/share/zoneinfo
    export hardeningDisable=all
  '' +
  # Ensure TMPDIR is set, and disable a test that removing the HOME
  # variable from the environment falls back to another home
  # directory.
  optionalString stdenv.isDarwin ''
    export TMPDIR=/tmp
    sed -i '28s/home_dir().is_some()/true/' ./src/test/run-pass/env-home-dir.rs
  '';

  inherit doCheck;

  # remove references to llvm-config in lib/rustlib/x86_64-unknown-linux-gnu/codegen-backends/librustc_codegen_llvm-llvm.so
  # and thus a transitive dependency on ncurses
  postInstall = ''
    find $out/lib -name "*.so" -type f -exec remove-references-to -t ${llvmShared} '{}' '+'
  '';

  configurePlatforms = [];

  # https://github.com/NixOS/nixpkgs/pull/21742#issuecomment-272305764
  # https://github.com/rust-lang/rust/issues/30181
  # enableParallelBuilding = false;

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with stdenv.lib; {
    homepage = https://www.rust-lang.org/;
    description = "A safe, concurrent, practical language";
    maintainers = with maintainers; [ madjar cstrahan wizeman globin havvy ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
    broken = broken;
  };
}
