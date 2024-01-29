{ lib, stdenv, pkgsBuildHost, pkgsHostHost
, file, curl, pkg-config, python3, openssl, cmake, zlib
, installShellFiles, makeWrapper, rustPlatform, rustc
, CoreFoundation, Security
, auditable ? !cargo-auditable.meta.broken
, cargo-auditable
, pkgsBuildBuild
}:

rustPlatform.buildRustPackage.override {
  cargo-auditable = cargo-auditable.bootstrap;
} ({
  pname = "cargo";
  inherit (rustc.unwrapped) version src;

  # the rust source tarball already has all the dependencies vendored, no need to fetch them again
  cargoVendorDir = "vendor";
  buildAndTestSubdir = "src/tools/cargo";

  inherit auditable;

  passthru = {
    rustc = rustc;
    inherit (rustc.unwrapped) tests;
  };

  # Upstream rustc still assumes that musl = static[1].  The fix for
  # this is to disable crt-static by default for non-static musl
  # targets.
  #
  # For every package apart from Cargo, we can fix this by just
  # patching rustc to not have crt-static by default.  But Cargo is
  # built with the upstream bootstrap binary for rustc, which we can't
  # easily patch.  This means we need to find another way to make sure
  # crt-static is not used during the build of pkgsMusl.cargo.
  #
  # By default, Cargo doesn't apply RUSTFLAGS when building build.rs
  # if --target is passed, so the only good way to set -crt-static for
  # build.rs files used in the Cargo build is to use the unstable
  # -Zhost-config Cargo feature.  This allows us to specify flags that
  # should be passed to rustc when building for the build platform.
  # We also need to use -Ztarget-applies-to-host, because using
  # -Zhost-config requires it.
  #
  # When doing this, we also have to specify the linker, or cargo
  # won't pass a -C linker= argument to rustc.  This will make rustc
  # try to use its default value of "cc", which won't be available
  # when cross-compiling.
  #
  # [1]: https://github.com/rust-lang/compiler-team/issues/422
  postPatch = lib.optionalString (with stdenv.buildPlatform; isMusl && !isStatic) ''
    mkdir -p .cargo
    cat <<EOF >> .cargo/config
    [host]
    rustflags = "-C target-feature=-crt-static"
    linker = "${pkgsBuildHost.stdenv.cc}/bin/${pkgsBuildHost.stdenv.cc.targetPrefix}cc"
    [unstable]
    host-config = true
    target-applies-to-host = true
    EOF
  '';

  # changes hash of vendor directory otherwise
  dontUpdateAutotoolsGnuConfigScripts = true;

  nativeBuildInputs = [
    pkg-config cmake installShellFiles makeWrapper
    (lib.getDev pkgsHostHost.curl)
    zlib
  ];
  buildInputs = [ file curl python3 openssl zlib ]
    ++ lib.optionals stdenv.isDarwin [ CoreFoundation Security ];

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

  doInstallCheck = !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.isElf;
  installCheckPhase = ''
    runHook preInstallCheck
    readelf -a $out/bin/.cargo-wrapped | grep -F 'Shared library: [libcurl.so'
    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://crates.io";
    description = "Downloads your Rust project's dependencies and builds your project";
    maintainers = teams.rust.members;
    license = [ licenses.mit licenses.asl20 ];
    platforms = platforms.unix;
    # https://github.com/alexcrichton/nghttp2-rs/issues/2
    broken = stdenv.hostPlatform.isx86 && stdenv.buildPlatform != stdenv.hostPlatform;
  };
}
// lib.optionalAttrs (stdenv.buildPlatform.rust.rustcTarget != stdenv.hostPlatform.rust.rustcTarget) {
  HOST_PKG_CONFIG_PATH="${pkgsBuildBuild.pkg-config}/bin/pkg-config";
})
