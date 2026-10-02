{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  kmod,
  pkg-config,
  pcsclite,
  nix-update-script,
  pname ? "token2-fido-bridge",
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname;
  version = "0.1.3";

  outputs = [
    "out"
  ];

  src = fetchFromGitHub {
    owner = "token2";
    repo = "token2-fido-bridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iu2qTRxEn/cgmWq4ifnZh26dRsLjT2r9BYnjatVirQw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/systemd/system" "$out/lib/systemd/system"
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/udev/rules.d" "$out/lib/udev/rules.d"
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/lib/modules-load.d" "$out/lib/modules-load.d"
    substituteInPlace packaging/token2-fido-bridge.service \
      --replace-fail "/sbin/modprobe" "${lib.makeBinPath [ kmod ]}/modprobe"
    substituteInPlace packaging/token2-fido-bridge.service \
      --replace-fail "/usr/bin/token2-fido-bridge" "$out/bin/token2-fido-bridge"
  '';

  separateDebugInfo = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildFeatures = [ "systemd" ];
  buildInputs = [
    pcsclite
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "use smartcards as FIDO2/WebAuthn keys (PC/SC to USB-HID bridge)";
    homepage = "https://github.com/token2/token2-fido-bridge";
    changelog = "https://github.com/token2/token2-fido-bridge/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "token2-fido-bridge";
    maintainers = [ lib.maintainers.TheOneWithTheBraid ];
    platforms = lib.platforms.linux;
  };
})
