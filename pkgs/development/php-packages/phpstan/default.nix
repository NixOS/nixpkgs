{
  fetchFromGitHub,
  lib,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phpstan";
  version = "2.1.30";

  src = fetchFromGitHub {
    owner = "phpstan";
    repo = "phpstan-src";
    tag = finalAttrs.version;
    hash = "sha256-G7ykOmt1YBjc8ppK+mninuZr8w9hWTx1DAkn4NkWfNM=";
  };

  vendorHash = "sha256-xh37+zSy4nKWDX7fOUBW56oLjNi0nW2eE7CZb9RQ/SA=";
  composerStrictValidation = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/phpstan/phpstan/releases/tag/${finalAttrs.version}";
    description = "PHP Static Analysis Tool";
    homepage = "https://github.com/phpstan/phpstan";
    longDescription = ''
      PHPStan focuses on finding errors in your code without actually
      running it. It catches whole classes of bugs even before you write
      tests for the code. It moves PHP closer to compiled languages in the
      sense that the correctness of each line of the code can be checked
      before you run the actual line.
    '';
    license = lib.licenses.mit;
    mainProgram = "phpstan";
    maintainers = [ lib.maintainers.patka ];
  };
})
