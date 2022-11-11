{ stdenv, lib, rustPlatform, rustc, Security, patchelf }:
rustPlatform.buildRustPackage {
  pname = "clippy";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/clippy";

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  buildInputs = [ rustc rustc.llvm ] ++ lib.optionals stdenv.isDarwin [ Security ];

  # fixes: error: the option `Z` is only accepted on the nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # Without disabling the test the build fails with:
  # error: failed to run custom build command for `rustc_llvm v0.0.0
  #   (/private/tmp/nix-build-clippy-1.36.0.drv-0/rustc-1.36.0-src/src/librustc_llvm)
  doCheck = false;

  preFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -add_rpath "${rustc}/lib" $out/bin/clippy-driver
  '';

  meta = with lib; {
    homepage = "https://rust-lang.github.io/rust-clippy/";
    description = "A bunch of lints to catch common mistakes and improve your Rust code";
    maintainers = with maintainers; [ basvandijk ];
    license = with licenses; [ mit asl20 ];
    platforms = platforms.unix;
  };
}
