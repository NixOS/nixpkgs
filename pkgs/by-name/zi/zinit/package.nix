{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installShellFiles,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zinit";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = finalAttrs.pname;
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-fnBV0LmC/wJm0pOITJ1mhiBqsg2F8AQJWvn0p/Bgo5Q=";
  };

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    # Source files
    mkdir -p $out/share/zinit
    install -m0644 zinit{,-side,-install,-autoload}.zsh $out/share/zinit
    install -m0755 share/git-process-output.zsh $out/share/zinit

    # Autocompletion
    installShellCompletion --zsh _zinit

    # Manpage
    installManPage doc/zinit.1

    runHook postInstall
  '';

  #TODO: output doc through zshelldoc

  meta = {
    homepage = "https://github.com/zdharma-continuum/zinit";
    description = "Flexible zsh plugin manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pasqui23
      sei40kr
    ];
  };
})
