{
  lib,
  fetchurl,
  fetchFromGitHub,
  php,
  versionCheckHook,
  runCommand,
}:

let
  version = "7.12.0";

  # The PHAR file is only required to get the `composer.lock` file
  psalm-phar = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    hash = "sha256-bWMkQ1N6ONcImYPRaxTX55hDSleOUB3YNC81ZWE20Xs=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  inherit version;

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-XKGOK/tY+MG2VdWFOy0OW5zuVJpYrdX6bBbckfR+c14=";
  };

  composerLock = runCommand "composer.lock" { } ''
    ${lib.getExe php} -r '$phar = new Phar("${psalm-phar}"); $phar->extractTo(".", "composer.lock");'
    cp composer.lock $out
  '';
  vendorHash = "sha256-VBfc+jBfem/yCaj38UdV4aBkcvC9nZQ1qZEmOVt1WlE=";

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
