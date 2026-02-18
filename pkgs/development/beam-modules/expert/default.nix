{
  erlang,
  fetchFromGitHub,
  mixRelease,
  lib,
  fetchMixDeps,
}:
let
  version = "0.1.0-rc.5";

  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "expert";
    tag = "v${version}";
    hash = "sha256-7e8zi3AFHESXyxTA0/YRmzR4L4tl19L0LHKaEM1l0P4=";
  };

  engineDeps = fetchMixDeps {
    pname = "mix-deps-expert-engine";

    inherit src version;
    hash = "sha256-PTyPLyo85N0BltX9oIRhHDGKgmNScb10N129wC8o6Q4=";

    preConfigure = ''
      cd apps/engine
    '';
  };
in
mixRelease rec {
  pname = "expert";
  inherit src version;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-T5OSjoglZfQa1lMO2lOZJ7yWoyxf6m33rKGuy4zq2AE=";

    preConfigure = ''
      cd apps/expert
    '';
  };

  mixReleaseName = "plain";

  preConfigure = ''
    ln -sv ${engineDeps} apps/engine/deps

    cd apps/expert
  '';

  postInstall = ''
    mv $out/bin/plain $out/bin/expert

    wrapProgram $out/bin/expert --add-flag "eval" --add-flag "System.no_halt(true); Application.ensure_all_started(:xp_expert)"
  '';

  removeCookie = false;

  passthru = {
    inherit engineDeps;
  };

  meta = {
    homepage = "https://github.com/elixir-lang/expert";
    changelog = "https://github.com/elixir-lang/expert/blob/v${version}/CHANGELOG.md";
    description = "Official Elixir Language Server Protocol implementation";
    longDescription = ''
      Expert is the official language server implementation for the Elixir programming language.
    '';
    license = lib.licenses.asl20;
    inherit (erlang.meta) platforms;
    mainProgram = "expert";
    teams = [ lib.teams.beam ];
  };
}
