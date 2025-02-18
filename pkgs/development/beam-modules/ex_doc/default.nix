{ lib, elixir, fetchFromGitHub, fetchMixDeps, mixRelease, nix-update-script }:
# Based on ../elixir-ls/default.nix

let
  pname = "ex_doc";
  version = "0.37.1";
  src = fetchFromGitHub {
    owner = "elixir-lang";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-PF+4bJ1FGr7t8khorlrB7rSSmNsGpyhC4HmWjw6j0JQ=";
  };
in
mixRelease {
  inherit pname version src elixir;

  stripDebug = true;

  mixFodDeps = fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version elixir;
    hash = "sha256-s4b6wuBJPdN0FPn76zbLCHzqJNEZ6E4nOyB1whUM2VY=";
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

  passthru.updateScript = nix-update-script { };

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
}
