<<<<<<< HEAD
{ lib, elixir, fetchFromGitHub, fetchMixDeps, mixRelease, nix-update-script }:
=======
{ lib, elixir, fetchFromGitHub, fetchMixDeps, mixRelease }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
# Based on the work of Hauleth
# None of this would have happened without him

let
  pname = "elixir-ls";
<<<<<<< HEAD
  version = "0.16.0";
=======
  pinData = lib.importJSON ./pin.json;
  version = pinData.version;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "elixir-lsp";
    repo = "elixir-ls";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-tEKwM5o3uXJ0cLY5USnQJ+HOGTSv6NDJvq+F/iqFEWs=";
=======
    sha256 = pinData.sha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fetchSubmodules = true;
  };
in
mixRelease  {
  inherit pname version src elixir;

<<<<<<< HEAD
  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-jpjqMIQ9fS4nkkKWZ80Mx5vULm5bvnNHy52ZQcR0y8c=";
=======
  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    sha256 = pinData.depsSha256;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
    mix do compile --no-deps-check, elixir_ls.release
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
<<<<<<< HEAD
    mainProgram = "elixir-ls";
    maintainers = teams.beam.members;
  };
  passthru.updateScript = nix-update-script { };
=======
    maintainers = teams.beam.members;
  };
  passthru.updateScript = ./update.sh;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
