{
  lib,
  fetchurl,
  fetchFromGitHub,
  php,
  versionCheckHook,
  runCommand,
}:

let
  version = "6.14.3";

  # The PHAR file is only required to get the `composer.lock` file
  psalm-phar = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    hash = "sha256-dqRI73CdY51K1aitIK6R74Y2sLb68l4ndNuTzRv8qRE=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  inherit version;

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-6MO16Ch3SR2kn48lTj64c/1DZDpsLjpZcFYmtiBhCCU=";
  };

  composerLock = runCommand "composer.lock" { } ''
    ${lib.getExe php} -r '$phar = new Phar("${psalm-phar}"); $phar->extractTo(".", "composer.lock");'
    cp composer.lock $out
  '';
  vendorHash = "sha256-2LlP0D7b07yXVGc/+pJUUWYXF8rsc4HiErBUt5SfZmw=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = [ lib.maintainers.patka ];
  };
})
