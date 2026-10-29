{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  # Softnet support ("--net-softnet") is disabled by default as it requires
  # passwordless-sudo when installed through nix. Alternatively users may install
  # softnet through other means with "setuid"-bit enabled.
  # See https://github.com/cirruslabs/softnet#installing
  enableSoftnet ? false,
  softnet,
  nix-update-script,
  testers,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tart";
  version = "2.36.0";

  src = fetchurl {
    url = "https://github.com/openai/tart/releases/download/${finalAttrs.version}/tart.tar.gz";
    hash = "sha256-xyqKuNeKZJih5CaIsaHsbFEs5GyjWjo74TDD3hRAx+g=";
  };
  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    # ./tart.app/Contents/MacOS/tart binary is required to be used in order to
    # trick macOS to pick tart.app/Contents/embedded.provision profile for elevated
    # privileges that Tart needs
    mkdir -p $out/bin $out/Applications
    cp -r tart.app $out/Applications/tart.app
    makeWrapper $out/Applications/tart.app/Contents/MacOS/tart $out/bin/tart \
      --prefix PATH : ${lib.makeBinPath (lib.optional enableSoftnet softnet)}
    install -Dm444 LICENSE $out/share/tart/LICENSE

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests.version = testers.testVersion {
    inherit (finalAttrs) version;
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "macOS and Linux VMs on Apple Silicon to use in CI and other automations";
    homepage = "https://tart.run";
    license = lib.licenses.fsl11Asl20;
    maintainers = with lib.maintainers; [
      emilytrau
      aduh95
    ];
    mainProgram = "tart";
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
