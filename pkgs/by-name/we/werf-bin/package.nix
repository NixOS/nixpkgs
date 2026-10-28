{
  fetchurl,
  installShellFiles,
  lib,
  stdenvNoCC,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "werf-bin";
  version = "3.12.1";
  __structuredAttrs = true;

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      mkUrl = x: "https://tuf.werf.io/targets/releases/${finalAttrs.version}/${x}/bin/werf";
    in
    {
      aarch64-darwin = fetchurl {
        url = mkUrl "darwin-arm64";
        hash = "sha256-mOccviRNa7qXIyD7PtYVLeNlzuWARh7cTEyGaHdGDVY=";
      };
      aarch64-linux = fetchurl {
        url = mkUrl "linux-arm64";
        hash = "sha256-52jN0fAlFkgGTF7K7JKxM89ZCny9R8Ibc6S2kuYCuaA=";
      };
      x86_64-linux = fetchurl {
        url = mkUrl "linux-amd64";
        hash = "sha256-yIvN9jIOc4iH/K++/gYO3C09tPtWYsdmilHTg47Wtvc=";
      };
    }
    .${system} or (throw "Unsupported system: ${system}");

  dontUnpack = true;
  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/werf

    runHook postInstall
  '';
  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    for shell in bash fish zsh; do
      installShellCompletion \
        --cmd werf \
        --$shell <($out/bin/werf completion --shell=$shell)
    done
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GitOps delivery tool";
    longDescription = ''
      werf is a CNCF Sandbox CLI tool to implement full-cycle CI/CD to
      Kubernetes easily. werf integrates into your CI system and leverages
      familiar and reliable technologies, such as Git, Dockerfile, Helm, and
      Buildah.
    '';
    homepage = "https://werf.io";
    changelog = "https://github.com/werf/werf/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.azahi ];
    mainProgram = "werf";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
