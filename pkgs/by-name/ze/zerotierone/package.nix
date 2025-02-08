{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  cargo,
  lzo,
  openssl,
  pkg-config,
  ronn,
  rustc,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zerotierone";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    tag = finalAttrs.version;
    hash = "sha256-D+7/ja5uYzH1iNd+Ti3k+dWOf5GvN4U+GuVBA9gxtTc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/rustybits";
    hash = "sha256-ADWCWJ5xl1Vl5lj386JBTjXEF6C6k6HkumXHcI4Uy0Q=";
  };

  patches = [
    ./0001-darwin-disable-link-time-optimization.patch
    ./0002-darwin-dont-build-for-both-arches.patch
  ];

  postPatch = ''
    # Workaround for: 'error inheriting `lints` from workspace root manifest's `workspace.lints`'
    # Git dependencies seem to be handled incorrectly by fetchCargoVendor.
    substituteInPlace $cargoDepsCopy/rustfsm-*/Cargo.toml \
      --replace-fail 'workspace = true' ""

    cp rustybits/Cargo.lock Cargo.lock
  '';

  preConfigure = ''
    patchShebangs ./doc/build.sh
    substituteInPlace ./doc/build.sh \
      --replace '/usr/bin/ronn' '${buildPackages.ronn}/bin/ronn' \

    substituteInPlace ./make-linux.mk \
      --replace '-march=armv6zk' "" \
      --replace '-mcpu=arm1176jzf-s' ""
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    lzo
    openssl
    zlib
  ];

  enableParallelBuilding = true;

  # Ensure Rust compiles for the right target
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTarget;

  preBuild =
    if stdenv.hostPlatform.isDarwin then
      ''
        makeFlagsArray+=("ARCH_FLAGS=") # disable multi-arch build
        if ! grep -q MACOS_VERSION_MIN=10.13 make-mac.mk; then
          echo "You may need to update MACOSX_DEPLOYMENT_TARGET to match the value in make-mac.mk"
          exit 1
        fi
        (cd rustybits && MACOSX_DEPLOYMENT_TARGET=10.13 cargo build -p zeroidc --release)

        cp \
          ./rustybits/target/${stdenv.hostPlatform.rust.rustcTarget}/release/libzeroidc.a \
          ./rustybits/target

        # zerotier uses the "FORCE" target as a phony target to force rebuilds.
        # We don't want to rebuild libzeroidc.a as we build want to build this library ourself for a single architecture
        touch FORCE
      ''
    else
      ''
        # Cargo won't compile to target/release but to target/<RUST_TARGET>/release when a target is
        # explicitly defined. The build-system however expects target/release. Hence we just symlink from
        # the latter to the former.
        mkdir -p rustybits/target/release
        ln -rs \
          ./rustybits/target/${stdenv.hostPlatform.rust.rustcTarget}/release/libzeroidc.a \
          ./rustybits/target/release/
      '';

  buildFlags = [
    "all"
    "selftest"
  ];

  __darwinAllowLocalNetworking = true;
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  checkPhase = ''
    runHook preCheck
    ./zerotier-selftest
    runHook postCheck
  '';

  installFlags = [
    # only linux has an install target, we borrow this for macOS as well
    "-f"
    "make-linux.mk"
    "DESTDIR=$$out/upstream"
  ];

  postInstall = ''
    mv $out/upstream/usr/sbin $out/bin

    mkdir -p $man/share
    mv $out/upstream/usr/share/man $man/share/man

    rm -rf $out/upstream
  '';

  outputs = [
    "out"
    "man"
  ];

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      sjmackenzie
      zimbatm
      ehmry
      obadz
      danielfullmer
      mic92 # also can test darwin
    ];
    platforms = platforms.unix;
  };
})
