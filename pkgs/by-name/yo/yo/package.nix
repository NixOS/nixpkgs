{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "yo";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "yeoman";
    repo = "yo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tTT+KjJ8Fol2IjPzuWpkd3SymODe8Jmge9sreSxBU5M=";
  };

  npmDepsHash = "sha256-bBGGZ5O4Nkw+nMZ5VAz7wjm8tIrCCvtv6TaXTwUCLPk=";

  dontNpmBuild = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI tool for running Yeoman generators";
    homepage = "https://github.com/yeoman/yo";
    license = lib.licenses.bsd2;
    mainProgram = "yo";
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
