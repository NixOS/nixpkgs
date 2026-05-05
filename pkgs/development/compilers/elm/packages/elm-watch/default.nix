{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "elm-watch";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "lydell";
    repo = "elm-watch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qfKXbONIqlfv9joAMhAxGMinfHaZvKEz2FL6YFl7OSI=";
    fetchSubmodules = true;
  };

  npmDepsHash = "sha256-ae4bUl5/GGAtYR7cc8om3C4/XjCUe8v3sWpIhIXBGV8=";

  npmFlags = [ "--ignore-scripts" ];

  dontNpmInstall = true;

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    local moduleDir="$out/lib/node_modules/elm-watch"
    mkdir -p "$moduleDir"

    cp -r build/. "$moduleDir/"
    cp -r node_modules "$moduleDir/"

    mkdir -p "$out/bin"
    makeWrapper ${nodejs}/bin/node "$out/bin/elm-watch" \
      --add-flags "$moduleDir/index.js"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "`elm make` in watch mode. Fast and reliable";
    homepage = "https://github.com/lydell/elm-watch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Myxogastria0808 ];
    mainProgram = "elm-watch";
    platforms = lib.platforms.all;
  };
})
