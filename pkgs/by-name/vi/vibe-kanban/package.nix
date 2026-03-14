{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  nodejs,
  pnpm,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "vibe-kanban";
  version = "0.0.155";

  src = fetchFromGitHub {
    owner = "BloopAI";
    repo = "vibe-kanban";
    tag = "v${version}-20260117094247";
    hash = "sha256-5t/mEeeddqygOT7+s+FZ2R08gKsrcbYoxv/1G9bC/XE=";
  };

  cargoHash = "sha256-RmIjC+URRPnOFncWVTp0nmSf+lfhsQ9dz/4AGeujAnQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    hash = "sha256-dbOKNE4Q1Z4VjbbrNoShi+/8FdGg4r4a12GkEEH7URw=";
    fetcherVersion = 3;
  };

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeWrapper
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    sqlite
  ];

  doCheck = false;

  preBuild = ''
    pushd frontend
    pnpm build
    popd
  '';

  postInstall = ''
    mv $out/bin/server $out/bin/vibe-kanban
    wrapProgram $out/bin/vibe-kanban
  '';

  meta = {
    description = "Get 10X more out of Claude Code, Gemini CLI, Codex, Amp and other coding agents";
    homepage = "https://vibekanban.com";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ conao3 ];
    mainProgram = "vibe-kanban";
    platforms = lib.platforms.unix;
  };
}
