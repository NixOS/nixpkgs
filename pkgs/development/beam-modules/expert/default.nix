{
  erlang,
  fetchFromGitHub,
  fetchMixDeps,
  lib,
  mixRelease,
  nix-update-script,
}:

mixRelease (finalAttrs: {
  pname = "expert";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "expert-lsp";
    repo = "expert";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aMkJ3wnnpQwZptQ8xSWuFel+nHhZtf2wBBt9E57Gr/g=";
  };

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${finalAttrs.pname}";
    inherit (finalAttrs) src version;
    hash = "sha256-IKAp+FSDEl+cGugxRvZ/We2rYDq8DaA88goFADQ5OKU=";

    preConfigure = ''
      cd apps/expert
    '';
  };

  mixReleaseName = "plain";

  engineDeps = fetchMixDeps {
    pname = "mix-deps-expert-engine";

    inherit (finalAttrs) src version;
    hash = "sha256-wpU4BUzyEEDlKI9SFjKT/NybqB7RF/ilQoTQk3oXN1A=";

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
    updateScript = nix-update-script {
      extraArgs = [ "--subpackage=engineDeps" ];
    };
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
