{
  lib,
  elixir,
  fetchFromGitHub,
  fetchMixDeps,
  mixRelease,
  nix-update-script,
}:
# Based on the work of Hauleth
# None of this would have happened without him

let
  pname = "elixir-ls";
  version = "0.21.1";
  src = fetchFromGitHub {
    owner = "elixir-lsp";
    repo = "elixir-ls";
    rev = "v${version}";
    hash = "sha256-OBLSj1nqv/p1FYg7DapCnr4EU2EW51MQM+YnZqDkcB4=";
    fetchSubmodules = true;
  };
in
mixRelease {
  inherit
    pname
    version
    src
    elixir
    ;

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-3PVMembw3CpYUQ/ynoPKmu0N5iZwoFu9uNjRS+kS4BY=";
  };

  # elixir-ls is an umbrella app
  # override configurePhase to not skip umbrella children
  configurePhase = ''
    runHook preConfigure
    mix deps.compile --no-deps-check
    runHook postConfigure
  '';

  # elixir-ls require a special step for release
  # compile and release need to be performed together because
  # of the no-deps-check requirement
  buildPhase = ''
    runHook preBuild
    mix do compile --no-deps-check, elixir_ls.release${lib.optionalString (lib.versionAtLeast elixir.version "1.16.0") "2"}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -Rv release $out/lib
    # Prepare the wrapper script
    substitute release/language_server.sh $out/bin/elixir-ls \
      --replace 'exec "''${dir}/launch.sh"' "exec $out/lib/launch.sh"
    chmod +x $out/bin/elixir-ls

    substitute release/debug_adapter.sh $out/bin/elixir-debug-adapter \
      --replace 'exec "''${dir}/launch.sh"' "exec $out/lib/launch.sh"
    chmod +x $out/bin/elixir-debug-adapter
    # prepare the launcher
    substituteInPlace $out/lib/launch.sh \
      --replace "ERL_LIBS=\"\$SCRIPTPATH:\$ERL_LIBS\"" \
                "ERL_LIBS=$out/lib:\$ERL_LIBS" \
      --replace "exec elixir" "exec ${elixir}/bin/elixir"
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
    maintainers = teams.beam.members;
  };
  passthru.updateScript = nix-update-script { };
}
