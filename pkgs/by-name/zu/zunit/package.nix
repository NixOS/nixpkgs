{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  zsh,
  revolver,
  installShellFiles,
  testers,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zunit";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "zunit-zsh";
    repo = "zunit";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GkBewb795piCaniZJZpGEZFhKaNs8p8swV5z34OegPY=";
    deepClone = true; # Needed in order to get "tests" folder
  };

  strictDeps = true;
  doCheck = true;
  doInstallCheck = true;

  nativeBuildInputs = [
    zsh
    installShellFiles
  ];
  nativeCheckInputs = [ revolver ];
  buildInputs = [
    zsh
    revolver
  ];

  postPatch = ''
    for i in $(find src/ -type f -print); do
      substituteInPlace $i \
        --replace-warn " revolver " " ${lib.getExe revolver} "
    done
  '';

  buildPhase = ''
    runHook preBuild

    zsh build.zsh

    runHook postBuild
  '';

  checkPhase = ''
    runHook preCheck

    HOME="$TEMPDIR" zsh zunit

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 zunit $out/bin/zunit

    runHook postInstall
  '';

  postInstall = ''
    installShellCompletion --cmd zunit --zsh zunit.zsh-completion
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    PATH=$PATH:$out/bin zunit --help

    runHook postInstallCheck
  '';

  passthru = {
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Powerful testing framework for ZSH projects";
    homepage = "https://zunit.xyz/";
    downloadPage = "https://github.com/zunit-zsh/zunit/releases";
    changelog = "https://github.com/zunit-zsh/zunit/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    mainProgram = "zunit";
    inherit (zsh.meta) platforms;
    maintainers = with lib.maintainers; [ d-brasher ];
  };
})
