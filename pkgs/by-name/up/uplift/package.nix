{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  gnupg,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "uplift";
  version = "2.26.0";

  src = fetchFromGitHub {
    owner = "gembaadvantage";
    repo = "uplift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cXZAxsQWjzYgoRAEKflJFcVN0OabdPHuJonJ0KMEaXs=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  vendorHash = "sha256-mjhNgy/QGHVdujmy94NQaoyvfrVmsIKZS3uWYK1XQr0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/gembaadvantage/uplift/internal/version.version=v${finalAttrs.version}"
    "-X=github.com/gembaadvantage/uplift/internal/version.gitCommit=v${finalAttrs.version}"
    "-X=github.com/gembaadvantage/uplift/internal/version.gitBranch=main"
    "-X=github.com/gembaadvantage/uplift/internal/version.buildDate=1970-01-01T00:00:00Z"
  ];

  nativeCheckInputs = [
    gitMinimal
    gnupg
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    git config --global user.name nixbld
    git config --global user.email nixbld@localhost
  '';

  # Test scripts use a /bin/bash shebang, which is unavailable in the sandbox
  checkFlags = [ "-skip=^TestExec_ShellScripts$" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic versioning the easy way";
    longDescription = ''
      By harnessing the power of Conventional Commits, Uplift
      simplifies the release management of your project through your
      use of commit messages.

      Built for Continuous Integration (CI), Uplift is incredibly
      simple to use, and its modular design allows you to choose which
      release cycle features you want to incorporate into your
      workflow. It adheres to the Semantic Versioning specification
      and plays nicely with other tools.
    '';
    homepage = "https://upliftci.dev";
    downloadPage = "https://github.com/gembaadvantage/uplift";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "uplift";
  };
})
