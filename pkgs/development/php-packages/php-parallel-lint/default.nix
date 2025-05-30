{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "php-parallel-lint";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "php-parallel-lint";
    repo = "PHP-Parallel-Lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g5e/yfvfq55MQDux3JRDvhaYEay68Q4u1VfIwDRgv7I=";
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-ySdLlqlGKZ6LgmAOBMkBNoCAqWrgMwE/Cj6ZEPEsCko=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";

  meta = {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    license = lib.licenses.bsd2;
    mainProgram = "parallel-lint";
    teams = [ lib.teams.php ];
  };
})
