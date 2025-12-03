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
  version = "0.18.0";

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-cALXl9CQZtg7kVAAWEu5CMbimrsjcfpxXLM1LhtxB/g=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-pfHzcYEEvj+x1/vLKhJ6bAsKGg19UisVK6h0xskhu74=";
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
