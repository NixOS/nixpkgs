{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ugreen-leds-cli";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "miskcoo";
    repo = "ugreen_leds_controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eSTOUHs4y6n4cacpjQAp4JIfyu40aBJEMsvuCN6RFZc=";
  };
  sourceRoot = "${finalAttrs.src.name}/cli";

  passthru.updateScript = nix-update-script { };

  postPatch = ''
    substituteInPlace Makefile --replace-warn "-static" ""
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 ugreen_leds_cli $out/bin/ugreen_leds_cli
    runHook postInstall
  '';

  meta = {
    description = "CLI tool to control UGREEN NAS LEDs";
    homepage = "https://github.com/miskcoo/ugreen_leds_controller";
    license = lib.licenses.mit;
    mainProgram = "ugreen_leds_cli";
    maintainers = with lib.maintainers; [ michaelvanstraten ];
    platforms = lib.platforms.linux;
  };
})
