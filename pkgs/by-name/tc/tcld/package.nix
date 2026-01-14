{
  buildGoModule,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "tcld";
  version = "0.41.0";
  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tcld";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-Jnm6l9Jj1mi9esDS6teKTEMhq7V1QD/dTl3qFhKsW4o=";
    # Populate values from the git repository; by doing this in 'postFetch' we
    # can delete '.git' afterwards and the 'src' should stay reproducible.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      # Replicate 'COMMIT' and 'DATE' variables from upstream's Makefile.
      git rev-parse --short=12 HEAD > $out/COMMIT
      git log -1 --format=%cd --date=iso-strict > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -exec rm -rf '{}' '+'
    '';
  };

  vendorHash = "sha256-GOko8nboj7eN4W84dqP3yLD6jK7GA0bANV0Tj+1GpgY=";

  subPackages = [ "cmd/tcld" ];
  ldflags = [
    "-s"
    "-w"
    "-X=github.com/temporalio/tcld/app.version=${finalAttrs.version}"
  ];

  # ldflags based on metadata from git.
  preBuild = ''
    ldflags+=" -X=github.com/temporalio/tcld/app.date=$(cat SOURCE_DATE_EPOCH)"
    ldflags+=" -X=github.com/temporalio/tcld/app.commit=$(cat COMMIT)"
  '';

  # FIXME: Remove after https://github.com/temporalio/tcld/pull/447 lands.
  patches = [ ./compgen.patch ];

  checkFlags = [
    # This test appears to require network access and does not work in the sandbox.
    "-skip=^TestFxDependencyInjection$"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd tcld --bash ${./bash_autocomplete}
    installShellCompletion --cmd tcld --zsh ${./zsh_autocomplete}
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Temporal cloud cli";
    homepage = "https://www.github.com/temporalio/tcld";
    changelog = "https://github.com/temporalio/tcld/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.mercury ];
    mainProgram = "tcld";
  };
})
