{
  lib,
  fetchFromGitHub,
  php,
  versionCheckHook,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  version = "6.5.0";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-RH4uPln90WrTdDF1S4i6e2OikPmIjTW3aM4gpM2qxgg=";
  };

  # Missing `composer.lock` from the repository.
  # Issue open at https://github.com/vimeo/psalm/issues/10446
  composerLock = ./composer.lock;
  vendorHash = "sha256-6eGj0gTXktm1zGHjHKKsMnudb9RfmAFgwcmDV/QMV5Y=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})
