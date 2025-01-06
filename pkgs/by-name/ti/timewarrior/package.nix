{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  asciidoctor,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "timewarrior";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "GothenburgBitFactory";
    repo = "timewarrior";
    rev = "v${version}";
    hash = "sha256-sc4AfdXLuA9evoGU6Z97+Hq7zj9nx093+nPALRkhziQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    asciidoctor
    installShellFiles
  ];

  dontUseCmakeBuildDir = true;

  postInstall = ''
    installShellCompletion --cmd timew \
      --bash completion/timew-completion.bash
  '';

  meta = {
    description = "Command-line time tracker";
    homepage = "https://timewarrior.net";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
      mrVanDalo
    ];
    mainProgram = "timew";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
