{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "grumphp";
  version = "2.21.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vQ6H8IpHHSfmlRcRgXcYhQeV3vmtkB3S5F8WltJqcKE=";
  };

  vendorHash = "sha256-Z3v5n7YhcyRF5iZhGa+iju81bObD0Nzls2V8DZ2WBVk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    teams = [ lib.teams.php ];
  };
})
