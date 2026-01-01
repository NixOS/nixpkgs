{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "tuios";
<<<<<<< HEAD
  version = "0.5.1";
=======
  version = "0.3.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "tuios";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-OBdVnKt3XkuzztgNcwla/EGqmAhNuRGkT6boJw5UITQ=";
  };

  vendorHash = "sha256-kDZRT/Ua+SaxyZ6RI9ZY2tqBgQBWo755fvQVRupBsUc=";
=======
    hash = "sha256-pIzHf4JT+BEa4On92uWscbZoEd3eRjf/B+aUART2V4M=";
  };

  vendorHash = "sha256-tu8GXE/wMq2i61gTlgdbfL38ehVppa/fz1WVXrsX+vk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.date=1970-01-01T00:00:00Z"
    "-X=main.builtBy=nixpkgs"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

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
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "tuios";
  };
})
