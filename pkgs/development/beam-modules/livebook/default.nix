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
  version = "0.17.0";

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-bdz6ufli+WC+3Fpd9uFK+OKOmL2Ogvmr5qsI85N1vgg=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-YyNrERVomIPaBJVKPTc5ZbWzaJk6b87RAC4QkBDicoQ=";
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
