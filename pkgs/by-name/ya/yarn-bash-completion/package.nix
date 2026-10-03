{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yarn-bash-completion";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "dsifford";
    repo = "yarn-completion";
    rev = "v${finalAttrs.version}";
    hash = "sha256-z7KPXeYPPRuaEPxgY6YqsLt9n8cSsW3n2FhOzVde1HU=";
  };

  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    installShellCompletion --cmd yarn ./yarn-completion.bash

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/dsifford/yarn-completion/";
    description = "Bash completion for Yarn";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DamienCassou ];
  };
})
