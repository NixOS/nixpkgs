{
  lib,
  stdenv,
  buildPackages,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  gitMinimal,
  tokei,
  installShellFiles,
  makeBinaryWrapper,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "tokui";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "zdyxry";
    repo = "tokui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v87AVzzNXTll0X+KEeU8/4z/kDm9r0ETvTUaumB8Pc0=";
  };

  vendorHash = "sha256-Om+htWFDfimXmIufFgqdF4olX1mXGGsrAUi97VTkSzg=";

  __structuredAttrs = true;

  ldflags = [
    "-X main.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    gitMinimal
    tokei
  ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}"
        else
          lib.getExe buildPackages.tokui;
    in
    ''
      installShellCompletion --cmd ${finalAttrs.meta.mainProgram} \
        --bash <(${exe} completion bash) \
        --fish <(${exe} completion fish) \
        --zsh <(${exe} completion zsh)
    ''
    + ''
      wrapProgram $out/bin/${finalAttrs.meta.mainProgram} \
        --prefix PATH : ${
          lib.makeBinPath [
            gitMinimal
            tokei
          ]
        }
    '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Interactive TUI for visualizing code statistics from tokei";
    mainProgram = "tokui";
    homepage = "https://github.com/zdyxry/tokui";
    changelog = "https://github.com/zdyxry/tokui/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20 # bundled copy of tokei uses this, pkg itself is mit
    ];
    maintainers = with lib.maintainers; [
      kangazero
    ];
  };
})
