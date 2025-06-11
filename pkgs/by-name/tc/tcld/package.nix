{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  installShellFiles,
  nix-update-script,
  ...
}:

buildGoModule (finalAttrs: {
  pname = "tcld";
  version = "0.40.0";
  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tcld";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-bIJSvop1T3yiLs/LTgFxIMmObfkVfvvnONyY4Bsjj8g=";
  };
  vendorHash = "sha256-GOko8nboj7eN4W84dqP3yLD6jK7GA0bANV0Tj+1GpgY=";
  ldFlags = [
    "-s"
    "-w"
  ];

  # FIXME: Remove after https://github.com/temporalio/tcld/pull/447 lands.
  patches = [ ./compgen.patch ];

  # NOTE: Some tests appear to require (local only?) network access, which
  # doesn't work in the sandbox.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd tcld --bash ${./bash_autocomplete}
    installShellCompletion --cmd tcld --zsh ${./zsh_autocomplete}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The temporal cloud cli.";
    homepage = "https://www.github.com/temporalio/tcld";
    license = lib.licenses.mit;
    teams = [ lib.teams.mercury ];
  };
})
