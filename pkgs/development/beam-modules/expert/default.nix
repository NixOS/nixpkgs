{
  _experimental-update-script-combinators,
  erlang,
  fetchFromGitHub,
  fetchMixDeps,
  gnused,
  lib,
  mixRelease,
  nix-update-script,
  nurl,
  writeShellApplication,
}:
let
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "expert-lsp";
    repo = "expert";
    tag = "v${version}";
    hash = "sha256-QpL58+rzXCl8jT/8sbvDmDZtcWz0+ZKg47XC33EwFyE=";
  };

  engineDeps = fetchMixDeps {
    pname = "mix-deps-expert-engine";

    inherit src version;
    hash = "sha256-4l0Tc/6sOcjGVQtzEOG6QP/ss8rqh+AOnwxuJsuCZCk=";

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
    hash = "sha256-q6OOealif+LClT0HlJTojDtvMk4MEtI/EjQHbLntiP8=";

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

    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (lib.getExe (writeShellApplication {
        name = "expert-update-engine";
        runtimeInputs = [
          gnused
          nurl
        ];
        text = ''
          nixpkgs="$(git rev-parse --show-toplevel)"
          engineHashOld=${engineDeps.hash}
          engineHashNew=$(nurl -e "(import $nixpkgs/. { }).$UPDATE_NIX_ATTR_PATH.engineDeps")
          echo "$UPDATE_NIX_ATTR_PATH.engineDeps.hash" >&2
          sed -i "s|$engineHashOld|$engineHashNew|" "$nixpkgs"/pkgs/development/beam-modules/expert/default.nix
        '';
      }))
    ];
  };

  meta = {
    homepage = "https://github.com/expert-lsp/expert";
    changelog = "https://github.com/expert-lsp/expert/blob/v0.1.1/CHANGELOG.md";
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
