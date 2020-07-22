{ stdenv, makeWrapper, fetchFromGitHub, rustPlatform
, openssh, openssl, pkgconfig, cmake, zlib, curl, libiconv
, CoreFoundation, Security }:

rustPlatform.buildRustPackage {
  pname = "rls";
  inherit (rustPlatform.rust.rustc) src version;

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/rls";

  preBuild = ''
    # client tests are flaky
    rm tests/client.rs
  '';

  # a nightly compiler is required unless we use this cheat code.
  RUSTC_BOOTSTRAP=1;

  # rls-rustc links to rustc_private crates
  CARGO_BUILD_RUSTFLAGS = if stdenv.isDarwin then "-C rpath" else null;

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ openssh openssl curl zlib libiconv makeWrapper rustPlatform.rust.rustc.llvm ]
    ++ (stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation Security ]);

  doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/rls --version
  '';

  RUST_SRC_PATH = rustPlatform.rustcSrc;
  postInstall = ''
    wrapProgram $out/bin/rls --set-default RUST_SRC_PATH ${rustPlatform.rustcSrc}
  '';

  meta = with stdenv.lib; {
    description = "Rust Language Server - provides information about Rust programs to IDEs and other tools";
    homepage = "https://github.com/rust-lang/rls/";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ symphorien ];
    platforms = platforms.all;
  };
}
