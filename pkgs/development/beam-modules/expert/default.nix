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
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "expert";
    tag = "v${version}";
    hash = "sha256-CGWWbzrBjCbz9S8f1nCLx2x6j4MFgsSd5XjgrxhuvzE=";
  };

  engineDeps = fetchMixDeps {
    pname = "mix-deps-expert-engine";

    inherit src version;
    hash = "sha256-relCdTBialz4Z/BpXZxmuhSYrvJqLINg/AVGfEhuDGo=";

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
    hash = "sha256-Rx5O77UEIDKcCz967h/8z1MAdaw0syzvLG5JOSaqgLE=";

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
