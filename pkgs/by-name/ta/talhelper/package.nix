{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "talhelper";
<<<<<<< HEAD
  version = "3.0.42";
=======
  version = "3.0.41";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "budimanjojo";
    repo = "talhelper";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-3yVKzny2R+ZA/fmIMJauul/FFNzxkB38LFozxHSpJD8=";
  };

  vendorHash = "sha256-BUcg08eVouYD9HAO/V1ranuot+ulWbSUqpJgJi5lHWw=";
=======
    hash = "sha256-m9BHf535wNSfDhttNKezwetf1tbblh01i00xP/OAuh0=";
  };

  vendorHash = "sha256-5cR2L/ex5efw6Wh+gNvZeyPZvTW/vX8LmqM74dwU2Bo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X github.com/budimanjojo/talhelper/v3/cmd.version=v${finalAttrs.version}"
  ];

  subPackages = [
    "."
    "./cmd"
  ];

  nativeBuildInputs = [ installShellFiles ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd talhelper \
      --bash <($out/bin/talhelper completion bash) \
      --fish <($out/bin/talhelper completion fish) \
      --zsh <($out/bin/talhelper completion zsh)
  '';

  meta = {
    changelog = "https://github.com/budimanjojo/talhelper/releases/tag/v${finalAttrs.version}";
    description = "Help creating Talos kubernetes cluster";
    longDescription = ''
      Talhelper is a helper tool to help creating Talos Linux cluster
      in your GitOps repository.
    '';
    homepage = "https://github.com/budimanjojo/talhelper";
    mainProgram = "talhelper";
    maintainers = with lib.maintainers; [ madeddie ];
    license = lib.licenses.bsd3;
  };
})
