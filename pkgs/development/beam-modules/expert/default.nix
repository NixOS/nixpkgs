{
  erlang,
  fetchFromGitHub,
  fetchMixDeps,
  lib,
  mixRelease,
  nix-update,
  writeShellApplication,
}:

mixRelease (finalAttrs: {
  pname = "expert";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "expert-lsp";
    repo = "expert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TcYSO+CY4ZC4uC6k5OhKFKwv70preoILHAan3KZlUqQ=";
  };

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${finalAttrs.pname}";
    inherit (finalAttrs) src version;
    hash = "sha256-N2krs4NNWytrN3K8lR5IGGroXVNuBzjks6IoD9D1rPM=";

    preConfigure = ''
      cd apps/expert
    '';
  };

  mixReleaseName = "plain";

  engineDeps = fetchMixDeps {
    pname = "mix-deps-expert-engine";

    inherit (finalAttrs) src version;
    hash = "sha256-evYg/yRk6ymV75kuWpY0pFODWWopozjnFHUa9MOFN/A=";

    preConfigure = ''
      cd apps/engine
    '';
  };

  preConfigure = ''
    ln -sv ${finalAttrs.engineDeps} apps/engine/deps

    cd apps/expert
  '';

  postInstall = ''
    mv $out/bin/plain $out/bin/expert

    wrapProgram $out/bin/expert --add-flag "eval" --add-flag "System.no_halt(true); Application.ensure_all_started(:xp_expert)"
  '';

  removeCookie = false;

  passthru = {
    updateScript = lib.getExe (writeShellApplication {
      name = "expert-update-script";
      runtimeInputs = [ nix-update ];
      text = ''
        nix-update beamPackages.expert
        nix-update beamPackages.expert.engineDeps
      '';
    });
  };

  meta = {
    homepage = "https://github.com/expert-lsp/expert";
    changelog = "https://github.com/expert-lsp/expert/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Official Elixir Language Server Protocol implementation";
    longDescription = ''
      Expert is the official language server implementation for the Elixir programming language.
    '';
    license = lib.licenses.asl20;
    inherit (erlang.meta) platforms;
    mainProgram = "expert";
    teams = [ lib.teams.beam ];
  };
})
