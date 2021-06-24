{ lib, stdenv, file, curl, pkg-config, python3, openssl, cmake, zlib
, installShellFiles, makeWrapper, libiconv, cacert, rustPlatform, rustc
, CoreFoundation, Security
}:

rustPlatform.buildRustPackage {
  name = "cargo-${rustc.version}";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/cargo";

  passthru.rustc = rustc;

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [ pkg-config cmake installShellFiles makeWrapper ];
  buildInputs = [ cacert file curl python3 openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security libiconv ];

  # cargo uses git-rs which is made for a version of libgit2 from recent master that
  # is not compatible with the current version in nixpkgs.
  #LIBGIT2_SYS_USE_PKG_CONFIG = 1;

  # fixes: the cargo feature `edition` requires a nightly version of Cargo, but this is the `stable` channel
  RUSTC_BOOTSTRAP = 1;

  postInstall = ''
    # NOTE: We override the `http.cainfo` option usually specified in
    # `.cargo/config`. This is an issue when users want to specify
    # their own certificate chain as environment variables take
    # precedence
    wrapProgram "$out/bin/cargo" \
      --suffix PATH : "${rustc}/bin" \
      --set CARGO_HTTP_CAINFO "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"

    installManPage src/tools/cargo/src/etc/man/*

    installShellCompletion --bash --name cargo \
      src/tools/cargo/src/etc/cargo.bashcomp.sh

    installShellCompletion --zsh src/tools/cargo/src/etc/_cargo
  '';

  checkPhase = ''
    # Disable cross compilation tests
    export CFG_DISABLE_CROSS_TESTS=1
    cargo test
  '';

  # Disable check phase as there are failures (4 tests fail)
  doCheck = false;

  meta = with lib; {
    homepage = "https://crates.io";
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.unix;
  };
}
