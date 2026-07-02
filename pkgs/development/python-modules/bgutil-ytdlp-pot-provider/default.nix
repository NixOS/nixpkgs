{
  lib,
  buildPythonPackage,
  cairo,
  fetchFromGitHub,
  fetchNpmDeps,
  giflib,
  hatchling,
  nodejs,
  npmHooks,
  pango,
  pixman,
  pkg-config,
  yt-dlp,
}:

buildPythonPackage rec {
  pname = "bgutil-ytdlp-pot-provider";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Brainicism";
    repo = "bgutil-ytdlp-pot-provider";
    tag = version;
    hash = "sha256-dhpataQ1HSCRPnm4k3K/NMaQPQdNrx8C4q855l7kbbQ=";
  };

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src = src + "/server";
    npmDepsFetcherVersion = 2;
    hash = "sha256-Qwwi6W+Oeu6ZeLmZP5vEfAKOJyivbULR5mlk7tcVIE8=";
  };

  npmRoot = "server";

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    cairo
    giflib
    pango
    pixman
  ];

  build-system = [ hatchling ];

  dependencies = [ yt-dlp ];

  doCheck = false; # no tests

  preBuild = ''
    cd server
    npx tsc
    npm prune --omit=dev
    cd ../plugin
  '';

  postInstall = ''
    cd ..

    mkdir -p $out/share/bgutil-ytdlp-pot-provider/
    cp -r server/{build,node_modules} $out/share/bgutil-ytdlp-pot-provider/
    makeWrapper ${lib.getExe nodejs} $out/bin/bgutil-ytdlp-pot-provider \
      --add-flags $out/share/bgutil-ytdlp-pot-provider/build/main.js

    cd plugin
  '';

  meta = {
    description = "Proof-of-origin token provider plugin for yt-dlp";
    homepage = "https://github.com/Brainicism/bgutil-ytdlp-pot-provider";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "bgutil-ytdlp-pot-provider";
  };
}
