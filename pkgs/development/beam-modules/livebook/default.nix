{
  lib,
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,

  bun,
  beamPackages,

  nixosTests,
  nix-update-script,
}:

beamPackages.mixRelease rec {
  pname = "livebook";
  version = "0.19.8";

  inherit (beamPackages) elixir;

  buildInputs = [ beamPackages.erlang ];

  nativeBuildInputs = [
    bun
    makeWrapper
    writableTmpDirAsHomeHook
  ];

  src = fetchFromGitHub {
    owner = "livebook-dev";
    repo = "livebook";
    tag = "v${version}";
    hash = "sha256-cIFnGUJ8yRnEBL9eu4Jpg1sMlTV1t/ybhHusLSFdZEY=";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-T74RmUORPdNibxdl+bRGyYyOdnKs1TyjtdutLtfLNLM=";
  };

  node_modules = stdenv.mkDerivation {
    pname = "${pname}-node_modules";
    inherit src version;
    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];
    dontBuild = true;
    dontFixup = true;
    installPhase = ''
      mkdir -p deps/phoenix deps/phoenix_html deps/phoenix_live_view
      echo '{"name": "phoenix", "version": "1.0.0"}' > deps/phoenix/package.json
      echo '{"name": "phoenix_html", "version": "1.0.0"}' > deps/phoenix_html/package.json
      echo '{"name": "phoenix_live_view", "version": "1.0.0"}' > deps/phoenix_live_view/package.json
      cd assets
      bun install \
        --no-cache \
        --backend=copyfile \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"
      mkdir -p $out
      cp -r node_modules $out/
      rm -rf $out/node_modules/phoenix
      rm -rf $out/node_modules/phoenix_html
      rm -rf $out/node_modules/phoenix_live_view
    '';
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = "sha256-XtEkedj5QJh1tveKKd5sh4xcC6Gol1DUweQKEw1jLgU=";
  };

  postPatch = ''
    substituteInPlace lib/mix/tasks/compile.ensure_livebook_priv.ex \
      --replace-fail 'Mix.Task.run("bun.install", ~w"--if-missing")' ':ok' \
      --replace-fail 'Mix.Task.run("bun", ~w"assets install")' ':ok' \
      --replace-fail 'Mix.Task.run("bun", ~w" assets run build")' ':ok'
  '';

  preBuild = ''
    cp -r ${node_modules}/node_modules assets/node_modules
    chmod -R +w assets/node_modules
    ln -sf ../../deps/phoenix assets/node_modules/phoenix
    ln -sf ../../deps/phoenix_html assets/node_modules/phoenix_html
    ln -sf ../../deps/phoenix_live_view assets/node_modules/phoenix_live_view
    pushd assets
    bun --bun ./node_modules/vite/bin/vite.js build
    popd
  '';

  postInstall =
    let
      path = lib.makeBinPath [
        beamPackages.elixir
        beamPackages.erlang
      ];
    in
    ''
      wrapProgram $out/bin/livebook \
        --prefix PATH : ${path} \
        --set MIX_REBAR3 ${beamPackages.rebar3}/bin/rebar3

      wrapProgram $out/bin/server \
        --prefix PATH : ${path}
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckProgramArg = [ "version" ];
  versionCheckKeepEnvironment = [ "HOME" ];
  doInstallCheck = true;

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
    mainProgram = "livebook";
    maintainers = with lib.maintainers; [
      munksgaard
      scvalex
    ];
    platforms = lib.platforms.unix;
    teams = [
      lib.teams.beam
      lib.teams.ngi
    ];
  };
}
