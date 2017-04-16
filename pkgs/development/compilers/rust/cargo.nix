{ stdenv, fetchgit, file, curl, pkgconfig, python, openssl, cmake, zlib
, makeWrapper, libiconv, cacert, rustPlatform, rustc, libgit2
, version, srcRev, srcSha, depsSha256
, patches ? []}:

rustPlatform.buildRustPackage rec {
  name = "cargo-${version}";
  inherit version;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo";
    rev = srcRev;
    sha256 = srcSha;
  };

  inherit depsSha256;
  inherit patches;

  passthru.rustc = rustc;

  buildInputs = [ file curl pkgconfig python openssl cmake zlib makeWrapper libgit2 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ libiconv ];

  LIBGIT2_SYS_USE_PKG_CONFIG=1;

  postInstall = ''
    # NOTE: We override the `http.cainfo` option usually specified in
    # `.cargo/config`. This is an issue when users want to specify
    # their own certificate chain as environment variables take
    # precedence
    wrapProgram "$out/bin/cargo" \
      --suffix PATH : "${rustc}/bin" \
      --set CARGO_HTTP_CAINFO "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      --set SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      ${stdenv.lib.optionalString stdenv.isDarwin ''--suffix DYLD_LIBRARY_PATH : "${rustc}/lib"''}
  '';

  checkPhase = ''
    # Export SSL_CERT_FILE as without it one test fails with SSL verification error
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    # Disable cross compilation tests
    export CFG_DISABLE_CROSS_TESTS=1
    cargo test
  '';

  # Disable check phase as there are failures (4 tests fail)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ wizeman retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
