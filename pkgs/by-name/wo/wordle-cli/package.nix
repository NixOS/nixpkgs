{
  lib,
  fetchFromGitHub,
  buildGoModule,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "wordle-cli";
  version = "1.0.9";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nimblebun";
    repo = "wordle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pJJiGUN1qflCQw+gSEEg8Q1HeTXaC1jgmHYoAbLk/Co=";
  };

  vendorHash = "sha256-+8SIvfQ50FvyNl3ECzgQFFydE1UcQfJrcmApK7Zq3Lc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Play Wordle in your command line";
    homepage = "https://github.com/nimblebun/wordle-cli";
    mainProgram = "wordle-cli";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
