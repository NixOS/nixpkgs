{
  lib,
  stdenv,
  fetchFromGitHub,
  gperf,
  libcap,
  meson,
  ninja,
  nix-update-script,
  openssl,
  pkg-config,
  sphinx,
  systemdLibs,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "systemd-netlogd";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "systemd";
    repo = "systemd-netlogd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eqv2hzISTfGbE5fc7+kbEqM0ATlfu1FccRZctByuHXs=";
  };

  patches = [
    ./use_bindir.patch
    ./use_mandir.patch
  ];

  mesonFlags = [ "--sysconfdir=${placeholder "out"}/etc/systemd" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    sphinx
  ];

  buildInputs = [
    gperf
    libcap
    openssl
    systemdLibs
  ];

  passthru = {
    # TODO: enable this when upstream reports their version number correctly
    # https://github.com/systemd/systemd-netlogd/issues/112
    # tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Forwards messages from the journal to other hosts over the network";
    homepage = "https://github.com/systemd/systemd-netlogd";
    changelog = "https://github.com/systemd/systemd-netlogd/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "systemd-netlogd";
  };
})
