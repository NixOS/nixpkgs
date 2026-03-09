{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,
  bash,
  coreutils,
  findutils,
  gawk,
  gnugrep,
  gnused,
  ripgrep,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ticket";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "wedow";
    repo = "ticket";
    tag = "v${finalAttrs.version}";
    hash = "sha256-orxqAwJBL+LHe+I9M+djYGa/yfvH67HdR/VVy8fdg90=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ticket $out/bin/ticket
    ln -s $out/bin/ticket $out/bin/tk

    wrapProgram $out/bin/ticket \
      --set PATH "${
        lib.makeBinPath [
          bash
          coreutils
          findutils
          gawk
          gnugrep
          gnused
          ripgrep
        ]
      }"

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/tk help | grep -q "minimal ticket system"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git-backed issue tracker for AI agents with dependency tracking";
    homepage = "https://github.com/wedow/ticket";
    changelog = "https://github.com/wedow/ticket/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      blsalin
    ];
    mainProgram = "tk";
  };
})
