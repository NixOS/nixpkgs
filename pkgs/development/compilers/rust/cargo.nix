{ stdenv, fetchFromGitHub, file, curl, pkgconfig, python, openssl, cmake, zlib
, makeWrapper, libiconv, cacert, rustPlatform, rustc, libgit2, darwin
, version, srcSha, cargoSha256
, patches ? []}:

rustPlatform.buildRustPackage rec {
  name = "cargo-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner  = "rust-lang";
    repo   = "cargo";
    rev    = version;
    sha256 = srcSha;
  };

  inherit cargoSha256;
  inherit patches;

  passthru.rustc = rustc;

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ file curl python openssl cmake zlib makeWrapper libgit2 ]
    # FIXME: Use impure version of CoreFoundation because of missing symbols.
    # CFURLSetResourcePropertyForKey is defined in the headers but there's no
    # corresponding implementation in the sources from opensource.apple.com.
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.CoreFoundation libiconv ];

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
    homepage = https://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ wizeman retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };
}
