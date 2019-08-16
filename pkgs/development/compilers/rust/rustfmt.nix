{ stdenv, rustPlatform, rustc, Security }:

rustPlatform.buildRustPackage rec {
  name = "rustfmt-${version}";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  preBuild = "pushd src/tools/rustfmt";
  postBuild = "popd";

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # As of 1.0.0 and rustc 1.30 rustfmt requires a nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # Without disabling the test the build fails with:
  #
  #   Compiling rustc_llvm v0.0.0 (/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)
  #   ...
  #   error: failed to run custom build command for `rustc_llvm v0.0.0
  #     (/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)`
  #
  #   Caused by:
  #     process didn't exit successfully:
  #       `/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/target/debug/build/rustc_llvm-4d3eb1eff32fd46b/build-script-build` (exit code: 101)
  #   --- stdout
  #   cargo:rerun-if-env-changed=REAL_LIBRARY_PATH_VAR
  #   cargo:rerun-if-env-changed=REAL_LIBRARY_PATH
  #
  #   --- stderr
  #   thread 'main' panicked at 'REAL_LIBRARY_PATH_VAR', src/libcore/option.rs:1036:5
  #   note: Run with `RUST_BACKTRACE=1` environment variable to display a backtrace.
  #
  # Setting the following:
  #
  #   # This mimics https://github.com/rust-lang/rust/blob/1.36.0/src/bootstrap/util.rs#L58:L70
  #   REAL_LIBRARY_PATH_VAR =
  #     if stdenv.isDarwin then "DYLD_LIBRARY_PATH"
  #     else "LD_LIBRARY_PATH";
  #
  # Results in:
  #
  #   Compiling rustc_llvm v0.0.0 (/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)
  #   ...
  #   error: failed to run custom build command for `rustc_llvm v0.0.0 (/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)`
  #
  #   Caused by:
  #     process didn't exit successfully: `/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/target/debug/build/rustc_llvm-4d3eb1eff32fd46b/build-script-build` (exit code: 1)
  #   --- stdout
  #   cargo:rerun-if-env-changed=REAL_LIBRARY_PATH_VAR
  #   cargo:rerun-if-env-changed=REAL_LIBRARY_PATH
  #   cargo:rerun-if-changed=llvm-config
  #   cargo:rerun-if-env-changed=LLVM_CONFIG
  #
  #
  #   failed to execute command: "llvm-config" "--version"
  #   error: No such file or directory (os error 2)
  #
  # Adding `llvmSharedForBuild` to rustc's `passthru` and adding
  # `rustc.llvmSharedForBuild` to the `buildInputs` fixes this but then the
  # build fails lateron with:
  #
  #   Compiling rustc_llvm v0.0.0 (/private/tmp/nix-build-rustfmt-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)
  #   ...
  #   error[E0658]: use of unstable library feature 'rustc_private': this crate is being loaded from the sysroot, an unstable location; did you mean to load this crate from crates.io via `Cargo.toml` instead?
  #    --> src/librustc_llvm/lib.rs:9:1
  #     |
  #   9 | extern crate rustc_cratesio_shim;
  #     | ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  #     |
  #     = note: for more information, see https://github.com/rust-lang/rust/issues/27812
  #     = help: add #![feature(rustc_private)] to the crate attributes to enable
  #
  #   error: aborting due to previous error
  #
  #   For more information about this error, try `rustc --explain E0658`.
  #
  #   error: Could not compile `rustc_llvm`.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ globin basvandijk ];
    platforms = platforms.all;
  };
}
