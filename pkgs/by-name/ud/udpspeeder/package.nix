{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "udpspeeder";
  version = "20230206.0";

  src = fetchFromGitHub {
    owner = "wangyu-";
    repo = "UDPspeeder";
    tag = finalAttrs.version;
    hash = "sha256-hrwkPSxY1DTEXt9vxDECDEJaoTDzBUS7rVI609uZwdU=";
  };

  postPatch = ''
    substituteInPlace makefile \
      --replace-fail " -static " " " \
      --replace-fail "\$(shell git rev-parse HEAD)" ${finalAttrs.version}
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ./speederv2 $out/bin/speederv2

    runHook postInstall
  '';

  nativeCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/wangyu-/UDPspeeder";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
    changelog = "https://github.com/wangyu-/UDPspeeder/releases/tag/${finalAttrs.version}";
    description = "Tunnel which Improves your Network Quality on a High-latency Lossy Link by using Forward Error Correction, possible for All Traffics(TCP/UDP/ICMP)";
    mainProgram = "speederv2";
  };
})
