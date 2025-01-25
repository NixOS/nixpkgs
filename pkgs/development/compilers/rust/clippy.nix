{
  stdenv,
  lib,
  rustPlatform,
  rustc,
  Security,
}:

rustPlatform.buildRustPackage {
  pname = "clippy";
  inherit (rustc) version src;

  separateDebugInfo = true;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/clippy";

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  buildInputs = [ rustc.llvm ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  # fixes: error: the option `Z` is only accepted on the nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # Without disabling the test the build fails with:
  # error: failed to run custom build command for `rustc_llvm v0.0.0
  #   (/private/tmp/nix-build-clippy-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)
  doCheck = false;

  # Clippy uses the rustc_driver and std private libraries, and Rust's build process forces them to have
  # an install name of `@rpath/...` [0] [1] instead of the standard on macOS, which is an absolute path
  # to itself.
  #
  # [0]: https://github.com/rust-lang/rust/blob/f77f4d55bdf9d8955d3292f709bd9830c2fdeca5/src/bootstrap/builder.rs#L1543
  # [1]: https://github.com/rust-lang/rust/blob/f77f4d55bdf9d8955d3292f709bd9830c2fdeca5/compiler/rustc_codegen_ssa/src/back/linker.rs#L323-L331
  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/clippy-driver"
    install_name_tool -add_rpath "${rustc.unwrapped}/lib" "$out/bin/cargo-clippy"
  '';

  meta = with lib; {
    homepage = "https://rust-lang.github.io/rust-clippy/";
    description = "Bunch of lints to catch common mistakes and improve your Rust code";
    mainProgram = "cargo-clippy";
    maintainers = with maintainers; [ basvandijk ] ++ teams.rust.members;
    license = with licenses; [
      mit
      asl20
    ];
    platforms = platforms.unix;
  };
}
