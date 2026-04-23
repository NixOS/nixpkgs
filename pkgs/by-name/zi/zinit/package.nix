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
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [ installShellFiles ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Source files
    mkdir -p $out/share/zinit
    install -m0444 zinit{,-side,-install,-autoload,-additional}.zsh _zinit $out/share/zinit
    install -m0555 share/git-process-output.zsh $out/share/zinit
    install -m0444 share/rpm2cpio.zsh $out/share/zinit

    # Autocompletion
    installShellCompletion --zsh _zinit

    # Manpage
    # otherwsise zinit tries to create them in the nix store
    mkdir -p $man/share/man/man{1..9}
    installManPage doc/zinit.1

    mkdir -p $doc/share/doc/zinit
    install -m0444 doc/zsdoc/*.adoc $doc/share/doc/zinit
    install -m0444 doc/HACKING.md $doc/share/doc/zinit

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/zinit/zinit.zsh \
      --replace-fail zinit.1 zinit.1.gz \
      --replace-fail "\''${ZINIT[BIN_DIR]}/doc" $man/share/man/man1 \
      --replace-fail "ZINIT[MAN_DIR]:=\''${ZPFX}/man" "ZINIT[MAN_DIR]:=$man/share/man"
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/zdharma-continuum/zinit";
    description = "Flexible zsh plugin manager";
    changelog = "https://github.com/zdharma-continuum/zinit/blob/${finalAttrs.src.rev}/doc/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      pasqui23
      sei40kr
      moraxyc
      kaynetik
    ];
  };
})
