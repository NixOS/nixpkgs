{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "word-snatchers-cli";
  version = "4.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akgondber";
    repo = "word-snatchers-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aZWtyKFMYsN9V/ihNfCBEv8K7tfdD+Ipp/ftiWOw2IE=";
  };

  npmDepsHash = "sha256-h67H78p3ASZY1r70xyG7jBhBbER6r2WnVgP17Wkay+g=";

  # cli.js still hard-codes 4.1.0 as the version string
  postPatch = ''
    substituteInPlace cli.js \
      --replace-fail 'cli.version("4.1.0")' 'cli.version("${finalAttrs.version}")'
  '';

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Console game of unscrambling letters to spell a word that fits a given definition";
    homepage = "https://github.com/akgondber/word-snatchers-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "word-snatchers-cli";
  };
})
