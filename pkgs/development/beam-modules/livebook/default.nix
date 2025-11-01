{
  lib,
  beamPackages,
  makeWrapper,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.17.3";

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-WElJgW2TxjeUgv6GZwq+hcgl6n4xr8mmCBPqoOGc1+w=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-18fmaNuu2KqTGhBBd+pSBfgnrHiqzXc3CMdSpC5lFs8=";
  };

  postInstall = ''
    wrapProgram $out/bin/livebook \
      --prefix PATH : ${
        lib.makeBinPath [
          beamPackages.elixir
          beamPackages.erlang
        ]
      } \
      --set MIX_REBAR3 ${beamPackages.rebar3}/bin/rebar3
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      livebook-service = nixosTests.livebook-service;
    };
  };

  meta = {
    license = lib.licenses.asl20;
    homepage = "https://livebook.dev/";
    description = "Automate code & data workflows with interactive Elixir notebooks";
    maintainers = with lib.maintainers; [
      munksgaard
      scvalex
    ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.beam ];
  };
}
