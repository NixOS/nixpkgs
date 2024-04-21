{ lib, elixir, fetchFromGitHub, fetchMixDeps, mixRelease, nix-update-script }:
# Based on ../elixir-ls/default.nix

let
  pname = "ex_doc";
  version = "0.32.1";
  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-nNUSx2Ywj04vgT/7BQEwoNtTl1NGmbvuIS4KbvUFYzs=";
  };
in
mixRelease {
  inherit pname version src elixir;

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-ZNHhWCZ3n2Y/XCsXVjbu4wbx/J95JdFP/2raACciAUU=";
  };

  configurePhase = ''
    runHook preConfigure
    mix deps.compile --no-deps-check
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    mix do escript.build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -v ex_doc $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/elixir-lang/ex_doc";
    description = ''
      ExDoc produces HTML and EPUB documentation for Elixir projects
    '';
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "ex_doc";
    maintainers = with maintainers; [chiroptical];
  };
  passthru.updateScript = nix-update-script { };
}
