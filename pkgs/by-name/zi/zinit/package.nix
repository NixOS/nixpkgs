{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  installShellFiles,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zinit";
  version = "3.14.0";

  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = "zinit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cBMGmFrveBes30aCSLMBO8WrtoPZeMNjcEQoQEzBNvM=";
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
    install -m0644 zinit{,-side,-install,-autoload}.zsh _zinit $out/share/zinit
    install -m0755 share/git-process-output.zsh $out/share/zinit

    # Autocompletion
    installShellCompletion --zsh _zinit

    # Manpage
    mkdir -p ${placeholder "man"}/share/man/man{1..9}
    installManPage doc/zinit.1

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/zinit/zinit.zsh \
      --replace-fail zinit.1 zinit.1.gz \
      --replace-fail "\''${ZINIT[BIN_DIR]}/doc" ${placeholder "man"}/share/man/man1 \
      --replace-fail "ZINIT[MAN_DIR]:=\''${ZPFX}/man" "ZINIT[MAN_DIR]:=${placeholder "man"}/share/man"
  '';

  #TODO: output doc through zshelldoc

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/zdharma-continuum/zinit";
    description = "Flexible zsh plugin manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pasqui23
      sei40kr
      moraxyc
    ];
  };
})
