{
  lib,
  elixir,
  fetchpatch,
  fetchFromGitHub,
  fetchMixDeps,
  makeWrapper,
  mixRelease,
  nix-update-script,
}:

mixRelease rec {
  pname = "elixir-ls";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "elixir-lsp";
    repo = "elixir-ls";
    rev = "v${version}";
    hash = "sha256-r4P+3MPniDNdF3SG2jfBbzHsoxn826eYd2tsv6bJBoI=";
  };

  inherit elixir;

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-8zs+99jwf+YX5SwD65FCPmfrYhTCx4AQGCGsDeCKxKc=";
  };

  patches = [
    # fix elixir deterministic support https://github.com/elixir-lsp/elixir-ls/pull/1216
    # remove > 0.28.1
    (fetchpatch {
      url = "https://github.com/elixir-lsp/elixir-ls/pull/1216.patch";
      hash = "sha256-J1Q7XQXWYuCMq48e09deQU71DOElZ2zMTzrceZMky+0=";
    })

    # patch wrapper script to remove elixir detection and inject necessary paths
    ./launch.sh.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  # elixir-ls require a special step for release
  # compile and release need to be performed together because
  # of the no-deps-check requirement
  buildPhase = ''
    runHook preBuild

    mix do compile --no-deps-check, elixir_ls.release${lib.optionalString (lib.versionAtLeast elixir.version "1.16.0") "2"}

    runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -Rv release $out/libexec

    substituteAllInPlace $out/libexec/launch.sh

    makeWrapper $out/libexec/language_server.sh $out/bin/elixir-ls \
      --set ELS_INSTALL_PREFIX "$out/libexec"

    makeWrapper $out/libexec/debug_adapter.sh $out/bin/elixir-debug-adapter \
      --set ELS_INSTALL_PREFIX "$out/libexec"

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
