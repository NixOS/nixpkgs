{
  lib,
  applyPatches,
  buildPythonPackage,
  cairo,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchpatch,
  hatchling,
  node-gyp,
  nodejs,
  npmHooks,
  pango,
  pixman,
  pkg-config,
  yt-dlp,
}:

buildPythonPackage rec {
  pname = "bgutil-ytdlp-pot-provider";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Brainicism";
    repo = "bgutil-ytdlp-pot-provider";
    tag = version;
    hash = "sha256-KKImGxFGjClM2wAk/L8nwauOkM/gEwRVMZhTP62ETqY=";
  };

  patches = [
    # Remove git dependency from package.json, can be removed with the next update
    (fetchpatch {
      url = "https://github.com/Brainicism/bgutil-ytdlp-pot-provider/commit/a35763a2add0738f3ea224b61b60f51134ccf690.patch";
      hash = "sha256-n5RVX1sXlqkj7jyfthybQFtYrzR0y4fijeJHHU9Bxrg=";
    })
    (fetchpatch {
      url = "https://github.com/Brainicism/bgutil-ytdlp-pot-provider/commit/cc2e2b3b17e0af8a8c7c6da0f31ab7d11825adfe.patch";
      hash = "sha256-fsJZRwgmIqydEx41cUJcLULNl/RwytIBFOJb26V4vEM=";
    })
  ];

  npmDeps = fetchNpmDeps {
    name = "${pname}-${version}-npm-deps";
    src =
      (applyPatches {
        inherit src patches;
      })
      + "/server";
    npmDepsFetcherVersion = 3;
    hash = "sha256-FCGu4oU0fxNP/vuD6k2a+r1YjzkVvaNYx8maeI42plk=";
  };

  npmRoot = "server";

  nativeBuildInputs = [
    node-gyp
    nodejs
    npmHooks.npmBuildHook
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [
    cairo
    pango
    pixman
  ];

  build-system = [ hatchling ];

  dependencies = [ yt-dlp ];

  doCheck = false; # no tests

  preBuild = ''
    cd server
    npx tsc
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
