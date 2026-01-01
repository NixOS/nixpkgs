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
<<<<<<< HEAD
  version = "0.18.2";
=======
  version = "0.17.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [ makeWrapper ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-VXb7TUeGjDcENd3AvAGTDYhBJCfibUzgO5nqpewRAt8=";
=======
    hash = "sha256-WElJgW2TxjeUgv6GZwq+hcgl6n4xr8mmCBPqoOGc1+w=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
<<<<<<< HEAD
    hash = "sha256-pfHzcYEEvj+x1/vLKhJ6bAsKGg19UisVK6h0xskhu74=";
=======
    hash = "sha256-18fmaNuu2KqTGhBBd+pSBfgnrHiqzXc3CMdSpC5lFs8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
