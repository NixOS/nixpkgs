{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpcs";
  version = "0.8.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "vpcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8urJy4eKHF3CSQtZ4bksNHnRx9KNVb1OYYjDNMTf0ZI=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc $(CCOPT)" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 src/vpcs -t $out/bin
    install -Dm644 man/vpcs.1 -t $out/share/man/man1

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Simple virtual PC simulator";
    longDescription = ''
      The VPCS (Virtual PC Simulator) can simulate up to 9 PCs. You can
      ping/traceroute them, or ping/traceroute the other hosts/routers from the
      VPCS when you study the Cisco routers in the dynamips.
    '';
    homepage = "https://github.com/GNS3/vpcs";
    changelog = "https://github.com/GNS3/vpcs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "vpcs";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
