{
  lib,
  elixir,
  fetchFromGitHub,
  fetchMixDeps,
  mixRelease,
  nix-update-script,
  pkgsBuildHost,

  # for tests
  beam27Packages,
  beam28Packages,
}:
# Based on ../elixir-ls/default.nix

let
  buildElixir = pkgsBuildHost.beam_minimal.packages.erlang.elixir;
  pname = "ex_doc";
  version = "0.38.4";
  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-/gZczKm/IF5QQemrdcda9oKVIGDFSqdiu8YrBwT6Mtk=";
  };
in
mixRelease {
  inherit
    pname
    version
    src
    elixir
    ;

  escriptBinName = "ex_doc";

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-TknrENa0Nb1Eobd4oTBl6TilPVEsw9+XjPdF3Ntq+DI=";
  };

  configurePhase = ''
    runHook preConfigure
    ${buildElixir}/bin/mix deps.compile --no-deps-check
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ${buildElixir}/bin/mix do escript.build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -v ex_doc $out/bin
    runHook postInstall
  '';

  passthru = {
    tests = {
      # ex_doc is the doc generation for OTP 27+, so let's make sure they build
      erlang_27 = beam27Packages.erlang;
      erlang_28 = beam28Packages.erlang;
    };

    updateScript = nix-update-script { };
  };

  meta = with lib; {
    homepage = "https://github.com/elixir-lang/ex_doc";
    description = ''
      ExDoc produces HTML and EPUB documentation for Elixir projects
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "ex_doc";
    maintainers = with maintainers; [ chiroptical ];
  };
}
