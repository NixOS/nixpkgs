{ stdenv, rustPlatform, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rustfmt";
  inherit (rustPlatform.rust.rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  preBuild = "pushd src/tools/rustfmt";
  preInstall = "popd";

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  # As of 1.0.0 and rustc 1.30 rustfmt requires a nightly compiler
  RUSTC_BOOTSTRAP = 1;

  # we run tests in debug mode so tests look for a debug build of
  # rustfmt. Anyway this adds nearly no compilation time.
  preCheck = ''
    cargo build
  '';

  meta = with stdenv.lib; {
    description = "A tool for formatting Rust code according to style guidelines";
    homepage = https://github.com/rust-lang-nursery/rustfmt;
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ globin basvandijk ];
    platforms = platforms.all;
  };
}
