{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  kubectl,
}:
buildGoModule (finalAttrs: {
  pname = "tfctl";
  version = "0.16.6";
  src = fetchFromGitHub {
    owner = "flux-iac";
    repo = "tofu-controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0J3gDRKYkIwT6iKMIfGUz+dRocjXiYQHR3dsPknyJzs=";
  };
  vendorHash = "sha256-49W9F4ILaliEPOipbEy9zzZjegY+VdIejgWLLLkCoos=";

  subPackages = [ "cmd/tfctl" ];
  ldflags = [
    "-X main.BuildSHA=${finalAttrs.src.tag}"
    "-X main.BuildVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  # Wrap with kubectl since tfctl/break_glass.go executes kubectl
  postInstall = ''
    wrapProgram $out/bin/tfctl \
      --prefix PATH : ${lib.makeBinPath [ kubectl ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish ; do
      $out/bin/tfctl completion "$shell" > "tfctl.$shell"
    done

    installShellCompletion tfctl.{bash,zsh,fish}
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/flux-iac/tofu-controller";
    description = "Cli for managing tofu-controller";
    mainProgram = "tfctl";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lunkentuss
    ];
  };
})
