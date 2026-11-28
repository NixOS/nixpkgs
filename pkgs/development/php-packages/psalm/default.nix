{
  lib,
  fetchurl,
  fetchFromGitHub,
  php,
  versionCheckHook,
  runCommand,
  nix-update-script,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  version = "7.22.1";

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-5MfhrUfZlIjz1VFz2R8HCAxSxGaFZsvLhcXFuelCbek=";
  };

  composerLock = runCommand "composer.lock" { } ''
    ${lib.getExe php} -r '$phar = new Phar("${finalAttrs.passthru.psalm-phar}"); $phar->extractTo(".", "composer.lock");'
    cp composer.lock $out
  '';
  vendorHash = "sha256-hKlPZ0YLG7BD50KE3VgQ7HDr1HFKMOyugbfRaokOtxs=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    # The PHAR file is only required to get the `composer.lock` file
    psalm-phar = fetchurl {
      url = "https://github.com/vimeo/psalm/releases/download/${finalAttrs.version}/psalm.phar";
      hash = "sha256-ifOV3N/cBT6UpyIZ6OrwaA81zdYK+FJTCAhU3dCITJc=";
    };
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage=psalm-phar"
        # nix-update looks up the hash position of a fetchurl in fetchurl itself
        "--override-filename=pkgs/development/php-packages/psalm/default.nix"
      ];
    };
  };

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = with lib.maintainers; [ piotrkwiecinski ];
  };
})
