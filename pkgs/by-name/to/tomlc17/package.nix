{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tomlc17";
  version = "251225";

  src = fetchFromGitHub {
    owner = "cktan";
    repo = "tomlc17";
    tag = "R${finalAttrs.version}";
    hash = "sha256-L3HKhfWCst7Pzb0kiaziYKtnPofivlHW6JibBteguvQ=";
  };

  doCheck = false; # tries to download toml-test suite

  installFlags = [
    "prefix=${placeholder "out"}"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^R(.*)" ];
  };

  meta = {
    homepage = "https://github.com/cktan/tomlc17";
    changelog = "https://github.com/cktan/tomlc17/releases/tag/R${finalAttrs.version}";
    description = "TOML parser in C17";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = with lib.platforms; unix;
  };
})
