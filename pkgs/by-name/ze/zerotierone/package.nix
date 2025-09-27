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
  fetchpatch,
}:

let
  pname = "zerotierone";
  version = "1.14.2";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    tag = version;
    hash = "sha256-D+7/ja5uYzH1iNd+Ti3k+dWOf5GvN4U+GuVBA9gxtTc=";
  };

in
stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    sourceRoot = "${src.name}/rustybits";
    hash = "sha256-CSpm4zBWKhcrM/KXGU6/51NSQ6hzpT44D2J+QETBtpQ=";

    # REMOVEME when https://github.com/NixOS/nixpkgs/pull/300532 is merged
    postBuild = ''
      pushd $out/git/730aadcc02767ae630e88f8f8c788a85d6bc81e6
      patch --verbose -p1 <${./0001-rustfsm-remove-unsupported-lints.workspace.patch}
      popd
    '';
  };

  patches = [
    ./0001-darwin-disable-link-time-optimization.patch
    # https://github.com/zerotier/ZeroTierOne/pull/2435
    (fetchpatch {
      url = "https://github.com/zerotier/ZeroTierOne/commit/8f56d484b681ea30cd28e19cab34499acfa6e64d.patch";
      hash = "sha256-UplkX2O4o8XKKTlR3ZsSG9E0y5gVhAagyepqwyGEYmA=";
    })
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
  ];

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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
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
