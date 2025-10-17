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
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "tart";
  version = "2.28.6";

  src = fetchurl {
    url = "https://github.com/cirruslabs/tart/releases/download/${finalAttrs.version}/tart.tar.gz";
    hash = "sha256-F6bYWVHtzXo6TH4CAvdF6qx7OCVvKACsh2KdRYFsxOw=";
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "macOS and Linux VMs on Apple Silicon to use in CI and other automations";
    homepage = "https://tart.run";
    license = licenses.fairsource09;
    maintainers = with maintainers; [
      emilytrau
      aduh95
    ];
    mainProgram = "tart";
    platforms = platforms.darwin;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
})
