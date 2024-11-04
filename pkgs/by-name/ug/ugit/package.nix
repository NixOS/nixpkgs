{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  git,
  fzf,
  bash,
  ncurses,
  curl,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "ugit";
  version = "5.8";

  src = fetchFromGitHub {
    owner = "Bhupesh-V";
    repo = "ugit";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-WnEyS2JKH6rrsYOeGEwughWq2LKrHPSjio3TOI0Xm4g=";
  };

  strictDeps = true;
  doInstallCheck = true;

  buildInputs = [
    fzf
    curl
    bash
    ncurses
  ];

  propagatedBuildInputs = [ git ];
  nativeInstallCheckInputs = [ ncurses ];

  postPatch = ''
    substituteInPlace ugit \
      --replace-fail "fzf " "${lib.getExe fzf} " \
      --replace-fail "curl" "${lib.getExe curl}" \
      --replace-fail "tput " "${ncurses}/bin/tput "
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 ugit $out/bin/ugit
    ln -s $out/bin/ugit $out/bin/git-undo
    install -Dm644 ugit.plugin.zsh $out/share/zsh/ugit/ugit.zsh

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    PATH=$PATH:$out/bin ugit --help

    runHook postInstallCheck
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool that helps undoing the last git command with grace";
    homepage = "https://github.com/Bhupesh-V/ugit";
    downloadPage = "https://github.com/Bhupesh-V/ugit/releases";
    license = lib.licenses.mit;
    mainProgram = "ugit";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
