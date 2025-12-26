{
  lib,
  fetchurl,
  fetchFromGitHub,
  php,
  versionCheckHook,
  runCommand,
}:

let
  version = "6.13.1";

  # The PHAR file is only required to get the `composer.lock` file
  psalm-phar = fetchurl {
    url = "https://github.com/vimeo/psalm/releases/download/${version}/psalm.phar";
    hash = "sha256-bOxm5LYiQDCY0hU998Wnnp2+x44sidfCf/OqlQ+1gvA=";
  };
in
php.buildComposerProject2 (finalAttrs: {
  pname = "psalm";
  inherit version;

  src = fetchFromGitHub {
    owner = "vimeo";
    repo = "psalm";
    tag = finalAttrs.version;
    hash = "sha256-QsANvg/QXJucjxwM6IF20mZu4DPw/RcBJV6+5tJkZB0=";
  };

  composerLock = runCommand "composer.lock" { } ''
    ${lib.getExe php} -r '$phar = new Phar("${psalm-phar}"); $phar->extractTo(".", "composer.lock");'
    cp composer.lock $out
  '';
  vendorHash = "sha256-gtN3Gml/gNeg7FBNnr6I7IV0zF6iK4oWproRESPbK/4=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/vimeo/psalm/releases/tag/${finalAttrs.version}";
    description = "Static analysis tool for finding errors in PHP applications";
    homepage = "https://github.com/vimeo/psalm";
    license = lib.licenses.mit;
    mainProgram = "psalm";
    maintainers = [ lib.maintainers.patka ];
  };
})
