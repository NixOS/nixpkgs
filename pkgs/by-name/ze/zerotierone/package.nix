{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, buildPackages
, cargo
, lzo
, openssl
, pkg-config
, ronn
, rustc
, zlib
, libiconv
, darwin
, fetchpatch
}:

let
  pname = "zerotierone";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "zerotier";
    repo = "ZeroTierOne";
    rev = version;
    sha256 = "sha256-YWcqALUB3ZEukL4er2FKcyNdEbuaf//QU5hRbKAfxDA=";
  };

in stdenv.mkDerivation {
  inherit pname version src;

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "jwt-0.16.0" = "sha256-P5aJnNlcLe9sBtXZzfqHdRvxNfm6DPBcfcKOVeLZxcM=";
      "rustfsm-0.1.0" = "sha256-q7J9QgN67iuoNhQC8SDVzUkjCNRXGiNCkE8OsQc5+oI=";
    };
  };
  patches = [
    # https://github.com/zerotier/ZeroTierOne/pull/2314
    (fetchpatch {
      url = "https://github.com/zerotier/ZeroTierOne/commit/f9c6ee0181acb1b77605d9a4e4106ac79aaacca3.patch";
      hash = "sha256-zw7KmaxiCH99Y0wQtOQM4u0ruxiePhvv/birxMQioJU=";
    })
    ./0001-darwin-disable-link-time-optimization.patch
  ];
  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    cp ${./Cargo.lock} rustybits/Cargo.lock
  '';


  preConfigure = ''
    cmp ./Cargo.lock ./rustybits/Cargo.lock || {
      echo 1>&2 "Please make sure that the derivation's Cargo.lock is identical to ./rustybits/Cargo.lock!"
      exit 1
    }

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
  ] ++ lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.SystemConfiguration
    darwin.apple_sdk.frameworks.CoreServices
  ];

  enableParallelBuilding = true;

  # Ensure Rust compiles for the right target
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTarget;

  preBuild = if stdenv.isDarwin then ''
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
  '' else ''
    # Cargo won't compile to target/release but to target/<RUST_TARGET>/release when a target is
    # explicitly defined. The build-system however expects target/release. Hence we just symlink from
    # the latter to the former.
    mkdir -p rustybits/target/release
    ln -rs \
      ./rustybits/target/${stdenv.hostPlatform.rust.rustcTarget}/release/libzeroidc.a \
      ./rustybits/target/release/
  '';

  buildFlags = [ "all" "selftest" ];

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;
  checkPhase = ''
    runHook preCheck
    ./zerotier-selftest
    runHook postCheck
  '';

  installFlags = [
    # only linux has an install target, we borrow this for macOS as well
    "-f" "make-linux.mk"
    "DESTDIR=$$out/upstream"
  ];

  postInstall = ''
    mv $out/upstream/usr/sbin $out/bin

    mkdir -p $man/share
    mv $out/upstream/usr/share/man $man/share/man

    rm -rf $out/upstream
  '';

  outputs = [ "out" "man" ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Create flat virtual Ethernet networks of almost unlimited size";
    homepage = "https://www.zerotier.com";
    license = licenses.bsl11;
    maintainers = with maintainers; [
      sjmackenzie zimbatm ehmry obadz danielfullmer
      mic92 # also can test darwin
    ];
    platforms = platforms.unix;
  };
}
