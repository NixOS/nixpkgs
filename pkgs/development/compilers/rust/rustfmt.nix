{ lib, stdenv, rustPlatform, Security, asNightly ? false }:

rustPlatform.buildRustPackage rec {
  pname = "rustfmt" + lib.optionalString asNightly "-nightly";
  inherit (rustPlatform.rust.rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/rustfmt";

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  buildInputs = lib.optional stdenv.isDarwin Security;

  # As of 1.0.0 and rustc 1.30 rustfmt requires a nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # As of rustc 1.45.0, these env vars are required to build rustfmt (due to
  # https://github.com/rust-lang/rust/pull/72001)
  CFG_RELEASE = rustPlatform.rust.rustc.version;
  CFG_RELEASE_CHANNEL = if asNightly then "nightly" else "stable";

  meta = with lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = "https://github.com/rust-lang-nursery/rustfmt";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ globin basvandijk ];
  };
}
