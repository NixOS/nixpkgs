{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  nix-update-script,
  testers,
  ubridge,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubridge";
  # uBridge became Linux-only in version 1.2.0.
  # https://github.com/GNS3/ubridge/releases/tag/v1.2.0
  version = if stdenv.hostPlatform.isDarwin then "1.1.1" else "1.2.3";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "ubridge";
    tag = "v${finalAttrs.version}";
    hash =
      if stdenv.hostPlatform.isDarwin then
        "sha256-2kt5naxMZwYX39sGyPqjiybFb8QtZuDbyBnMPeZS9U0="
      else
        "sha256-d/5E3JRel5/DGsowg10YxRX7JzcmuwtdP3Jo38GjwEc=";
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

  passthru = {
    tests.version = testers.testVersion {
      package = ubridge;
      command = "ubridge -v";
    };
    updateScript = nix-update-script {
      extraArgs = [ "--system=x86_64-linux" ];
    };
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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
