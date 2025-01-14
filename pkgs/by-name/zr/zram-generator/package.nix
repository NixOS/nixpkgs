{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  bash,
  ronn,
  systemd,
  kmod,
  nixosTests,
}:

rustPlatform.buildRustPackage rec {
  pname = "zram-generator";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-aGBvvjGKZ5biruwmJ0ITakqPhTWs9hspRIE9QirqstA=";
  };

  # RFE: Include Cargo.lock in sources
  # https://github.com/systemd/zram-generator/issues/65
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    substituteInPlace Makefile \
      --replace-fail 'target/$(BUILDTYPE)' 'target/${stdenv.hostPlatform.rust.rustcTargetSpec}/$(BUILDTYPE)'
    substituteInPlace src/generator.rs \
      --replace-fail 'Command::new("systemd-detect-virt")' 'Command::new("${systemd}/bin/systemd-detect-virt")' \
      --replace-fail 'Command::new("modprobe")' 'Command::new("${kmod}/bin/modprobe")'
    substituteInPlace src/config.rs \
      --replace-fail 'Command::new("/bin/sh")' 'Command::new("${bash}/bin/sh")'
  '';

  nativeBuildInputs = [
    pkg-config
    ronn
  ];

  buildInputs = [
    systemd
  ];

  preBuild = ''
    # embedded into the binary at build time
    # https://github.com/systemd/zram-generator/blob/v1.2.0/Makefile#LL11-L11C56
    export SYSTEMD_UTIL_DIR=$($PKG_CONFIG --variable=systemdutildir systemd)
  '';

  dontCargoInstall = true;

  installFlags = [
    "-o program" # already built by cargoBuildHook
    "PREFIX=$(out)"
    "SYSTEMD_SYSTEM_UNIT_DIR=$(out)/lib/systemd/system"
    "SYSTEMD_SYSTEM_GENERATOR_DIR=$(out)/lib/systemd/system-generators"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) zram-generator;
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    homepage = "https://github.com/systemd/zram-generator";
    license = licenses.mit;
    description = "Systemd unit generator for zram devices";
    maintainers = with maintainers; [ nickcao ];
  };
}
