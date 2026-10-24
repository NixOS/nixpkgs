{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "zsa-udev-rules";
  version = "0-unstable-2024-08-21";

  src = fetchFromGitHub {
    owner = "zsa";
    repo = "wally";
    rev = "dba608a2c08e66d41c5530444e9097eab5ede627";
    hash = "sha256-a9KTJntFAkd7r66DDSPsukKqVEJGjPF14XLlRYHYY8s=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  # Only copies udevs rules
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp dist/linux64/50-oryx.rules $out/lib/udev/rules.d/
    cp dist/linux64/50-oryx-legacy.rules $out/lib/udev/rules.d/
    cp dist/linux64/50-wally.rules $out/lib/udev/rules.d/
  '';

  # The newest tag predates the current rules by two years.
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "udev rules for ZSA devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davidak ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/zsa/wally/wiki/Linux-install#2-create-a-udev-rule-file";
  };
}
