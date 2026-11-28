{
  ghosttyBackend ? true,

  lib,
  stdenv,

  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  libghostty-vt,
  pkg-config,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "tuios" + lib.optionalString (!ghosttyBackend) "-go";
  version = "0.13.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "tuios";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K5HdrurAchfL8OCLTXRej+s7EjYhicoFgKlFdKQaeP0=";
  };

  vendorHash = "sha256-6PboUWkjWLZjD0dxfLKmLjK0CV8S2cl2iMxt+3CybfU=";

  tags = lib.optionals ghosttyBackend [ "ghostty" ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=nixpkgs"
  ];

  env = {
    GOWORK = "off";
    CGO_ENABLED = if ghosttyBackend then "1" else "0";
  };

  __darwinAllowLocalNetworking = true;

  subPackages = [
    "cmd/tuios"
    "cmd/tuios-web"
  ];

  nativeBuildInputs = [ installShellFiles ] ++ lib.optionals ghosttyBackend [ pkg-config ];
  buildInputs = lib.optionals ghosttyBackend [ libghostty-vt ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  postVersionCheck = ''
    "$out/bin/tuios" --version \
      | grep --fixed-strings -- "[${if ghosttyBackend then "ghostty" else "pure-Go"} backend]"
  '';

  checkFlags =
    let
      skippedTests = [
        "TestCheckTransferShapeRefusesWhatBundleWorktreeCannotSend" # needs a repo
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
      --bash <($out/bin/${finalAttrs.meta.mainProgram} completion bash) \
      --fish <($out/bin/${finalAttrs.meta.mainProgram} completion fish) \
      --zsh <($out/bin/${finalAttrs.meta.mainProgram} completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal-based window manager";
    homepage = "https://github.com/Gaurav-Gosain/tuios";
    changelog = "https://github.com/Gaurav-Gosain/tuios/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kpbaks
      adamcstephens
    ];
    mainProgram = "tuios";
  };
})
