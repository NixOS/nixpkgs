{ stdenv, removeReferencesTo, pkgsBuildBuild, pkgsBuildHost, pkgsBuildTarget
, fetchurl, fetchgit, fetchzip, file, python2, tzdata, ps
, llvm_7, ncurses, darwin, git, cmake, curl, rustPlatform
, which, libffi, gdb
, withBundledLLVM ? false
}:

let
  inherit (stdenv.lib) optional optionalString;
  inherit (darwin.apple_sdk.frameworks) Security;

  llvmSharedForBuild = pkgsBuildBuild.llvm_7.override { enableSharedLibraries = true; };
  llvmSharedForHost = pkgsBuildHost.llvm_7.override { enableSharedLibraries = true; };
  llvmSharedForTarget = pkgsBuildTarget.llvm_7.override { enableSharedLibraries = true; };

  # For use at runtime
  llvmShared = llvm_7.override { enableSharedLibraries = true; };
in stdenv.mkDerivation rec {
  pname = "rustc";
  version = "1.34.0";

  src = fetchurl {
    url = "https://static.rust-lang.org/dist/rustc-${version}-src.tar.gz";
    sha256 = "0n8z1wngkxab1rvixqg6w8b727hzpnm9wp9h8iy3mpbrzp7mmj3s";
  };

  __darwinAllowLocalNetworking = true;

  # rustc complains about modified source files otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  # Running the default `strip -S` command on Darwin corrupts the
  # .rlib files in "lib/".
  #
  # See https://github.com/NixOS/nixpkgs/pull/34227
  #
  # Running `strip -S` when cross compiling can harm the cross rlibs.
  # See: https://github.com/NixOS/nixpkgs/pull/56540#issuecomment-471624656
  stripDebugList = [ "bin" ];


  NIX_LDFLAGS =
       # when linking stage1 libstd: cc: undefined reference to `__cxa_begin_catch'
       optional (stdenv.isLinux && !withBundledLLVM) "--push-state --as-needed -lstdc++ --pop-state"
    ++ optional (stdenv.isDarwin && !withBundledLLVM) "-lc++"
    ++ optional stdenv.isDarwin "-rpath ${llvmSharedForHost}/lib";

  # Enable nightly features in stable compiles (used for
  # bootstrapping, see https://github.com/rust-lang/rust/pull/37265).
  # This loosens the hard restrictions on bootstrapping-compiler
  # versions.
  RUSTC_BOOTSTRAP = "1";

  # Increase codegen units to introduce parallelism within the compiler.
  RUSTFLAGS = "-Ccodegen-units=10";

  # We need rust to build rust. If we don't provide it, configure will try to download it.
  # Reference: https://github.com/rust-lang/rust/blob/master/src/bootstrap/configure.py
  configureFlags = let
    setBuild  = "--set=target.${stdenv.buildPlatform.config}";
    setHost   = "--set=target.${stdenv.hostPlatform.config}";
    setTarget = "--set=target.${stdenv.targetPlatform.config}";
    ccForBuild  = "${pkgsBuildBuild.targetPackages.stdenv.cc}/bin/${pkgsBuildBuild.targetPackages.stdenv.cc.targetPrefix}cc";
    cxxForBuild = "${pkgsBuildBuild.targetPackages.stdenv.cc}/bin/${pkgsBuildBuild.targetPackages.stdenv.cc.targetPrefix}c++";
    ccForHost  = "${pkgsBuildHost.targetPackages.stdenv.cc}/bin/${pkgsBuildHost.targetPackages.stdenv.cc.targetPrefix}cc";
    cxxForHost = "${pkgsBuildHost.targetPackages.stdenv.cc}/bin/${pkgsBuildHost.targetPackages.stdenv.cc.targetPrefix}c++";
    ccForTarget  = "${pkgsBuildTarget.targetPackages.stdenv.cc}/bin/${pkgsBuildTarget.targetPackages.stdenv.cc.targetPrefix}cc";
    cxxForTarget = "${pkgsBuildTarget.targetPackages.stdenv.cc}/bin/${pkgsBuildTarget.targetPackages.stdenv.cc.targetPrefix}c++";
  in [
    "--release-channel=stable"
    "--set=build.rustc=${rustPlatform.rust.rustc}/bin/rustc"
    "--set=build.cargo=${rustPlatform.rust.cargo}/bin/cargo"
    "--enable-rpath"
    "--enable-vendor"
    "--build=${stdenv.buildPlatform.config}"
    "--host=${stdenv.hostPlatform.config}"
    "--target=${stdenv.targetPlatform.config}"

    "${setBuild}.cc=${ccForBuild}"
    "${setHost}.cc=${ccForHost}"
    "${setTarget}.cc=${ccForTarget}"

    "${setBuild}.linker=${ccForBuild}"
    "${setHost}.linker=${ccForHost}"
    "${setTarget}.linker=${ccForTarget}"

    "${setBuild}.cxx=${cxxForBuild}"
    "${setHost}.cxx=${cxxForHost}"
    "${setTarget}.cxx=${cxxForTarget}"
  ] ++ optional (!withBundledLLVM) [
    "--enable-llvm-link-shared"
    "${setBuild}.llvm-config=${llvmSharedForBuild}/bin/llvm-config"
    "${setHost}.llvm-config=${llvmSharedForHost}/bin/llvm-config"
    "${setTarget}.llvm-config=${llvmSharedForTarget}/bin/llvm-config"
  ];

  # The bootstrap.py will generated a Makefile that then executes the build.
  # The BOOTSTRAP_ARGS used by this Makefile must include all flags to pass
  # to the bootstrap builder.
  postConfigure = ''
    substituteInPlace Makefile \
      --replace 'BOOTSTRAP_ARGS :=' 'BOOTSTRAP_ARGS := --jobs $(NIX_BUILD_CORES)'
  '';

  patches = [
    ./patches/net-tcp-disable-tests.patch

    # Re-evaluate if this we need to disable this one
    #./patches/stdsimd-disable-doctest.patch

    # Fails on hydra - not locally; the exact reason is unknown.
    # Comments in the test suggest that some non-reproducible environment
    # variables such $RANDOM can make it fail.
    # ./patches/disable-test-inherit-env.patch
  ];

  # the rust build system complains that nix alters the checksums
  dontFixLibtool = true;

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

  # rustc unfortunately needs cmake to compile llvm-rt but doesn't
  # use it for the normal build. This disables cmake in Nix.
  dontUseCmakeConfigure = true;

  # ps is needed for one of the test cases
  nativeBuildInputs = [
    file python2 ps rustPlatform.rust.rustc git cmake
    which libffi removeReferencesTo
  ] # Only needed for the debuginfo tests
    ++ optional (!stdenv.isDarwin) gdb;

  buildInputs = optional stdenv.isDarwin Security
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

  # 1. Upstream is not running tests on aarch64:
  # see https://github.com/rust-lang/rust/issues/49807#issuecomment-380860567
  # So we do the same.
  # 2. Tests run out of memory for i686
  #doCheck = !stdenv.isAarch64 && !stdenv.isi686;

  # Disabled for now; see https://github.com/NixOS/nixpkgs/pull/42348#issuecomment-402115598.
  doCheck = false;

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
  };
}
