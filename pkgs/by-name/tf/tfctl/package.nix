{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  kubectl,
}:
buildGoModule (finalAttrs: {
  name = "tfctl";
  version = "0.15.1";
  src = fetchFromGitHub {
    owner = "flux-iac";
    repo = "tofu-controller";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rA3HLO4sD8UmcebGGFxyg0zFpDHCzFHjHwMxPw8MiRU=";
  };
  vendorHash = "sha256-NhXgWuxSuurP46DBWOviFzCINJKaTb1mINRYeYcnnH8=";

  subPackages = [ "cmd/tfctl" ];
  ldflags = [
    "-X main.BuildSHA=${finalAttrs.src.rev}"
    "-X main.BuildVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ kubectl ];

  patchPhase = ''
    substituteInPlace tfctl/break_glass.go \
      --replace-fail 'exec.Command("kubectl"' 'exec.Command("${lib.getExe kubectl}"'
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish ; do
      $out/bin/tfctl completion "$shell" > "tfctl.$shell"
    done

    installShellCompletion tfctl.{bash,zsh,fish}
  '';

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
