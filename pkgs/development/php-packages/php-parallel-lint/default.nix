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
  vendorHash = "sha256-tAS4EAFb3SyL3j6oIB+YTyZPQcrRbyDFt4QzOwEB8wU=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Tool to check syntax of PHP files faster than serial check with fancier output";
    homepage = "https://github.com/php-parallel-lint/PHP-Parallel-Lint";
    license = lib.licenses.bsd2;
    mainProgram = "parallel-lint";
    teams = [ lib.teams.php ];
  };
})
