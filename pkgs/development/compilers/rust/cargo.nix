{ lib, stdenv, pkgsHostHost
, file, curl, pkg-config, python3, openssl, cmake, zlib
, installShellFiles, makeWrapper, cacert, rustPlatform, rustc
, libiconv, CoreFoundation, Security
}:

rustPlatform.buildRustPackage {
  pname = "cargo";
  inherit (rustc) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/cargo";

  passthru = {
    rustc = rustc;
    inherit (rustc) tests;
  };

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [
    pkg-config cmake installShellFiles makeWrapper
    (lib.getDev pkgsHostHost.curl)
  ];
  buildInputs = [ cacert file curl python3 openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ libiconv CoreFoundation Security ];

  # cargo uses git-rs which is made for a version of libgit2 from recent master that
  # is not compatible with the current version in nixpkgs.
  #LIBGIT2_SYS_USE_PKG_CONFIG = 1;

  # fixes: the cargo feature `edition` requires a nightly version of Cargo, but this is the `stable` channel
  RUSTC_BOOTSTRAP = 1;

  postInstall = ''
    wrapProgram "$out/bin/cargo" --suffix PATH : "${rustc}/bin"

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

  doInstallCheck = !stdenv.hostPlatform.isStatic &&
    stdenv.hostPlatform.parsed.kernel.execFormat == lib.systems.parse.execFormats.elf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/bin/.cargo-wrapped | grep -F 'Shared library: [libcurl.so'
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://crates.io";
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = with maintainers; [ retrry ];
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.unix;
  };
}
