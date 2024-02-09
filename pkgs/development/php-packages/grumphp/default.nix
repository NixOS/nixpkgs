{ fetchFromGitHub
, lib
, php
}:

php.buildComposerProject (finalAttrs: {
  pname = "grumphp";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "phpro";
    repo = "grumphp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-htddnBQ6VkVlZ+d5UYu2kyzrbfACRCZRdYtdGGaZ+FE=";
  };

  vendorHash = "sha256-UJsWZ5dYW8sEft/i122x7bJJ33TVjEp5CU65rW/tHhk=";

  meta = {
    changelog = "https://github.com/phpro/grumphp/releases/tag/v${finalAttrs.version}";
    description = "A PHP code-quality tool";
    homepage = "https://github.com/phpro/grumphp";
    license = lib.licenses.mit;
    mainProgram = "grumphp";
    maintainers = lib.teams.php.members;
  };
})
