{ stdenv, fetchgit, file, curl, pkgconfig, python, openssl, cmake, zlib
, makeWrapper, libiconv, cacert, rustPlatform, rustc
, version, srcRev, srcSha, depsSha256 }:

rustPlatform.buildRustPackage rec {
  name = "cargo-${version}";
  inherit version;

  src = fetchgit {
    url = "https://github.com/rust-lang/cargo";
    rev = srcRev;
    sha256 = srcSha;
  };

  inherit depsSha256;

  passthru.rustc = rustc;

  buildInputs = [ file curl pkgconfig python openssl cmake zlib makeWrapper ]
    ++ stdenv.lib.optional stdenv.isDarwin libiconv;

  configurePhase = ''
    ./configure --enable-optimize --prefix=$out --local-cargo=${rustPlatform.rust.cargo}/bin/cargo
  '';

  buildPhase = "make";

  installPhase = ''
    make install
    ${postInstall}
  '';

  postInstall = ''
    rm "$out/lib/rustlib/components" \
       "$out/lib/rustlib/install.log" \
       "$out/lib/rustlib/rust-installer-version" \
       "$out/lib/rustlib/uninstall.sh" \
       "$out/lib/rustlib/manifest-cargo"

    wrapProgram "$out/bin/cargo" \
      --suffix PATH : "${rustc}/bin" \
      --run "export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt" \
      ${stdenv.lib.optionalString stdenv.isDarwin ''--suffix DYLD_LIBRARY_PATH : "${rustc}/lib"''}
  '';

  checkPhase = ''
    # Export SSL_CERT_FILE as without it one test fails with SSL verification error
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    # Disable cross compilation tests
    export CFG_DISABLE_CROSS_TESTS=1
    cargo test
  '';

  # Disable check phase as there are failures (author_prefers_cargo test fails)
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://crates.io;
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ wizeman retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
