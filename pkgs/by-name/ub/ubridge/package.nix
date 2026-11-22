{
  lib,
  stdenv,
  criterion,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  nixosTests,
  pkg-config,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubridge";
  version = "1.3.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KNhzRJB141KcTCa22BtIn7IzdY+/z8V8jysvfh56cws=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr/local/bin" "$out/bin" \
      --replace-fail "setcap" "#setcap"
  '';

  buildInputs = [ libpcap ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 ubridge $out/bin/ubridge

    runHook postInstall
  '';

  doCheck = true;
  nativeCheckInputs = [ pkg-config ];
  checkInputs = [ criterion ];
  checkTarget = "test";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "-v";

  passthru = {
    tests.nixos = nixosTests.gns3-server;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Bridge for UDP tunnels, Ethernet, TAP, and VMnet interfaces";
    longDescription = ''
      uBridge is a simple application to create user-land bridges between
      various technologies. Currently bridging between UDP tunnels, Ethernet
      and TAP interfaces is supported. Packet capture is also supported.
    '';
    homepage = "https://github.com/GNS3/ubridge";
    changelog = "https://github.com/GNS3/ubridge/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "ubridge";
    maintainers = with lib.maintainers; [
      anthonyroussel
    ];
    platforms = lib.platforms.linux;
  };
})
