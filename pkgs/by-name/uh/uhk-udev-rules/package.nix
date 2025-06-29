{
  lib,
  stdenv,
  uhk-agent,
  udevCheckHook,
}:

stdenv.mkDerivation {
  pname = "uhk-udev-rules";
  inherit (uhk-agent) version;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    install -D -m 644 ${uhk-agent.out}/opt/uhk-agent/rules/50-uhk60.rules $out/lib/udev/rules.d/50-uhk60.rules
    runHook postInstall
  '';

  meta = {
    description = "udev rules for UHK keyboards from https://ultimatehackingkeyboard.com";
    inherit (uhk-agent.meta) license;
    maintainers = [ lib.maintainers.ngiger ];
  };
}
