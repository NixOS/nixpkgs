{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tiddlywiki";
  version = "5.3.8";

  src = fetchFromGitHub {
    owner = "tiddlywiki";
    repo = "tiddlywiki5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nBBjD9JB4tliRJ5N1aK3pc9PzCHG1fByj7vWtKnNEzI=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
  ];

  installPhase = ''
    mkdir -p $out/lib/node_modules/tiddlywiki/
    mv * $out/lib/node_modules/tiddlywiki/

    makeWrapper ${lib.getExe nodejs} $out/bin/tiddlywiki \
      --add-flags "$out/lib/node_modules/tiddlywiki/tiddlywiki.js"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Self-contained JavaScript wiki for the browser, Node.js, AWS Lambda etc";
    homepage = "https://tiddlywiki.com";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "tiddlywiki";
  };
})
