{
  fetchurl,
  installShellFiles,
  lib,
  stdenvNoCC,
  versionCheckHook,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "werf-bin";
  version = "3.11.0";
  __structuredAttrs = true;

  src =
    let
      inherit (stdenvNoCC.hostPlatform) system;
      mkUrl = x: "https://tuf.werf.io/targets/releases/${finalAttrs.version}/${x}/bin/werf";
    in
    {
      aarch64-darwin = fetchurl {
        url = mkUrl "darwin-arm64";
        hash = "sha256-/J5F4X2yYc/5yTnt5Q11gYuI1nd4aplNdAQpS0/FxiA=";
      };
      aarch64-linux = fetchurl {
        url = mkUrl "linux-arm64";
        hash = "sha256-srSS7d/9w68IGBR4XQ7ByY9AFktD+yT9h9O8dodWLCE=";
      };
      x86_64-linux = fetchurl {
        url = mkUrl "linux-amd64";
        hash = "sha256-wiyCR76ztRjE4dQXEtUt82x7XPrrrB+dlsez7D01j1o=";
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
