{
  lib,
  stdenv,
  fetchFromGitHub,
  callPackage,
  zig,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xit";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "xit-vcs";
    repo = "xit";
    rev = "33d6feef019b1cbef6ef4a564437a05f53d66831";
    hash = "sha256-hkP1fHnQXA6Atfuoi1/KjZLRwwjd7xmUhanmSHbxgD8=";
  };

  nativeBuildInputs = [
    zig
  ];

  zigBuildFlags = [
    "--system"
    "${callPackage ./build.zig.zon.nix { }}"
  ];

  zigCheckFlags = finalAttrs.zigBuildFlags;

  installPhase = ''
    runHook preInstall
    install -Dm755 zig-out/bin/xit $out/bin/xit
    runHook postInstall
  '';

  __structuredAttrs = true;
  strictDeps = true;
  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Git-compatible version control system written in Zig";
    longDescription = ''
      xit is an experimental version control system written in Zig. It aims to
      be compatible with Git remotes and workflows while combining
      snapshot-based storage with patch-based merging. Bundled TUI.
    '';
    homepage = "https://github.com/xit-vcs/xit";
    changelog = "https://github.com/xit-vcs/xit/commit/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "xit";
    platforms = lib.platforms.unix;
  };
})
