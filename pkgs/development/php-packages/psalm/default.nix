{
  lib,
  fetchurl,
  fetchFromGitHub,
  php,
  versionCheckHook,
  runCommand,
}:

let
  version = "6.8.6";

  # The PHAR file is only required to get the `composer.lock` file
  psalm-phar = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    hash = "sha256-nPvA/pxBMJe4Ux4NmFOdrEmKqRqmwz8gFlCgsB0GbPI=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  inherit version;

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-CewFeIUG+/5QCRpoPSOv1gqwBL9voBf4zgIzdnhk2t8=";
  };

  composerLock = runCommand "composer.lock" { } ''
    ${lib.getExe php} -r '$phar = new Phar("${psalm-phar}"); $phar->extractTo(".", "composer.lock");'
    cp composer.lock $out
  '';
  vendorHash = "sha256-QObqXzazypumDnFtfNiFSZdpZ7PbsBZZBUsS3fseZok=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  meta = {
    broken = lib.versionOlder php.version "8.2";
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = lib.teams.php.members;
  };
})
