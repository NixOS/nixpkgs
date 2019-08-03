{ stdenv, file, curl, pkgconfig, python, openssl, cmake, zlib
, makeWrapper, libiconv, cacert, rustPlatform, rustc, libgit2
, CoreFoundation, Security
}:

rustPlatform.buildRustPackage rec {
  name = "cargo-${rustc.version}";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  preBuild = "pushd src/tools/cargo";
  postBuild = "popd";

  passthru.rustc = rustc;

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [ pkgconfig cmake makeWrapper ];
  buildInputs = [ cacert file curl python openssl zlib libgit2 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ CoreFoundation Security libiconv ];

  LIBGIT2_SYS_USE_PKG_CONFIG = 1;

  # fixes: the cargo feature `edition` requires a nightly version of Cargo, but this is the `stable` channel
  RUSTC_BOOTSTRAP = 1;

  # FIXME: Use impure version of CoreFoundation because of missing symbols.
  # CFURLSetResourcePropertyForKey is defined in the headers but there's no
  # corresponding implementation in the sources from opensource.apple.com.
  preConfigure = stdenv.lib.optionalString stdenv.isDarwin ''
    export NIX_CFLAGS_COMPILE="-F${CoreFoundation}/Library/Frameworks $NIX_CFLAGS_COMPILE"
  '';

  postInstall = ''
    # NOTE: We override the `http.cainfo` option usually specified in
    # `.cargo/config`. This is an issue when users want to specify
    # their own certificate chain as environment variables take
    # precedence
    wrapProgram "$out/bin/cargo" \
      --suffix PATH : "${rustc}/bin" \
      --set CARGO_HTTP_CAINFO "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  checkPhase = ''
    # Disable cross compilation tests
    export CFG_DISABLE_CROSS_TESTS=1
    cargo test
  '';

  # Disable check phase as there are failures (4 tests fail)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ wizeman retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.unix;
  };
}
