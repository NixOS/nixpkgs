{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  libxcb,
  dbus,
  bash,
  procps,
  nano,
  watch,
}:

rustPlatform.buildRustPackage (attrs: {
  pname = "tattoy";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "tattoy-org";
    repo = "tattoy";
    tag = "tattoy-v${attrs.version}";
    hash = "sha256-44rXygZVbwwC/jOB69iHydsjYr/WeVU4Eky3BPqJzyc=";
  };

  cargoHash = "sha256-DJyml8J9XXKD2t1dQz+OrVDFcq6PLMoDlhiLo86D3CM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    libxcb
  ];

  nativeCheckInputs = [
    bash
    nano
    procps
    watch
  ];

  checkFlags = [
    # e2e tests currently fail
    # see https://github.com/tattoy-org/tattoy/pull/104/files for discussion
    # re-enable after PR merged
    "--skip e2e"
    "--skip gpu"
  ];

  useNextest = true;

  meta = {
    description = "Text-based compositor for modern terminals";
    homepage = "https://github.com/tattoy-org/tattoy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      DieracDelta
    ];
    mainProgram = "tattoy";
    platforms = lib.platforms.unix;
  };
})
