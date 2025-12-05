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
  libiconv,
  # enableUnfree enables building the zerotier controller, which is subject to
  # a source-available license that permits non-commercial use
  enableUnfree ? false,
}:

let
  pname = "zerotierone";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    tag = version;
    hash = "sha256-bFfRz695sbdZJd5DIfF7j8lbEqWHSaIqHq/AfXZgZ4s=";
  };

in
stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/rustybits";
    hash = "sha256-u3gqETbn4I+mtUeSkSym4s+qhA3eDb4Qaq7bl58M+AY=";
  };

  patches = [
    ./0001-darwin-disable-link-time-optimization.patch
    # https://github.com/zerotier/ZeroTierOne/pull/2435
    ./0002-Support-single-arch-builds-on-macOS.patch
  ];

  postPatch = ''
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  enableParallelBuilding = true;

  # Ensure Rust compiles for the right target
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTarget;

  preBuild =
    if stdenv.hostPlatform.isDarwin then
      ''
        # building multiple architectures at the same time from nixpkgs is not supported
        makeFlagsArray+=("ARCH=${stdenv.hostPlatform.darwinArch}")
        if ! grep -q MACOS_VERSION_MIN=10.13 make-mac.mk; then
          echo "You may need to update MACOSX_DEPLOYMENT_TARGET to match the value in make-mac.mk"
          exit 1
        fi
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
  ]
  ++ lib.optional enableUnfree "ZT_NONFREE=1";

  # darwin: disabled due to a test which fails to bind to 127.0.0.1 in a sandbox.
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform && !stdenv.hostPlatform.isDarwin;

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = if enableUnfree then licenses.unfree else licenses.mpl20;
    maintainers = with maintainers; [
      sjmackenzie
      zimbatm
      obadz
      danielfullmer
      mic92 # also can test darwin
    ];
    platforms = platforms.unix;
  };
}
