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
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "tiddlywiki";
    repo = "tiddlywiki5";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MvX10TwSRQxB8qqLtnlxCelDL6CDlSHGWccv4Xh630I=";
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
    maintainers = [ ];
    mainProgram = "tiddlywiki";
  };
})
