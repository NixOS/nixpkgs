{
  lib,
  buildGoModule,
  fetchFromGitHub,
  gitMinimal,
  nix-update-script,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "tea-dash";
  version = "0.3.8";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gbarany";
    repo = "tea-dash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0MUzkbQzyp1TRZaHnCmIR+1MjBzmqBndaBmVTBMCPGI=";
  };

  vendorHash = "sha256-CNty+TgwujfTguhwIXurtz2ILBnGYonVjgrJOtXO644=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/gbarany/tea-dash/internal/build.Version=${finalAttrs.version}"
    "-X=github.com/gbarany/tea-dash/internal/build.Commit=${finalAttrs.src.rev}"
    "-X=github.com/gbarany/tea-dash/internal/build.Date=1970-01-01T00:00:00Z"
  ];

  nativeCheckInputs = [ gitMinimal ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
  };

  meta = {
    description = "gh-dash-style terminal dashboard (TUI) for Gitea & Forgejo — PRs, issues, notifications, Actions runs, and branches";
    homepage = "https://github.com/gbarany/tea-dash";
    changelog = "https://github.com/gbarany/tea-dash/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ frantathefranta ];
    mainProgram = "tea-dash";
  };
})
