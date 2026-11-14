{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "tldr-lint";
  version = "0.0.22";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tldr-pages";
    repo = "tldr-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bqgK82UfmDCj/sRGEFWZx19G9eU/R55iCuO1PAct0Gg=";
  };

  npmDepsHash = "sha256-N+tYI0YmY7240yx7v+JjJdzx0ha4RoF9BuCMK5s2tlo=";

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Linting tool to validate tldr pages";
    homepage = "https://github.com/tldr-pages/tldr-lint";
    changelog = "https://github.com/tldr-pages/tldr-lint/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "tldr-lint";
    platforms = lib.platforms.all;
  };
})
