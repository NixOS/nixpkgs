{
  lib,
  elixir,
  fetchFromGitHub,
  makeWrapper,
  stdenv,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "elixir-ls";
  version = "0.29.3";

  src = fetchFromGitHub {
    owner = "elixir-lsp";
    repo = "elixir-ls";
    rev = "v${version}";
    hash = "sha256-ikx0adlDrkUpMXPEbPtIsb2/1wcOt1jLwciVdBEKnss=";
  };

  patches = [
    # patch wrapper script to remove elixir detection and inject necessary paths
    ./launch.sh.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # for substitution
  env.elixir = elixir;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    cp -R . $out
    ln -s $out/VERSION $out/scripts/VERSION

    substituteAllInPlace $out/scripts/launch.sh

    mkdir -p $out/bin

    makeWrapper $out/scripts/language_server.sh $out/bin/elixir-ls \
      --set ELS_LOCAL "1"

    makeWrapper $out/scripts/debug_adapter.sh $out/bin/elixir-debug-adapter \
      --set ELS_LOCAL "1"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/elixir-lsp/elixir-ls";
    description = ''
      A frontend-independent IDE "smartness" server for Elixir.
      Implements the "Language Server Protocol" standard and provides debugger support via the "Debug Adapter Protocol"
    '';
    longDescription = ''
      The Elixir Language Server provides a server that runs in the background, providing IDEs, editors, and other tools with information about Elixir Mix projects.
      It adheres to the Language Server Protocol, a standard for frontend-independent IDE support.
      Debugger integration is accomplished through the similar VS Code Debug Protocol.
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "elixir-ls";
    teams = [ teams.beam ];
  };
  passthru.updateScript = nix-update-script { };
}
