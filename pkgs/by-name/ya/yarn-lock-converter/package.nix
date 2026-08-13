{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  testers,
  yarn-lock-converter,
  yarn-berry_3,
  makeBinaryWrapper,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "yarn-lock-converter";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "vht";
    repo = "yarn-lock-converter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AFetTjQZwXjlgLFE9YWHt82j3y8Ej25HYLed3tw/IxU=";
  };

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    inherit (finalAttrs) src;
    hash = "sha256-dpZJYiRJzd6QbrRJccXpEkkNgtbBJ669lY5UQmcy8Yg=";
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_3.yarnBerryConfigHook
    yarn-berry_3
    makeBinaryWrapper
  ];

  installPhase = ''
    runHook preInstall

    yarn config set nodeLinker "node-modules"
    yarn install --mode=skip-build --inline-builds
    mkdir -p $out/lib/node_modules/yarn-lock-converter
    chmod +x ./index.js
    rm yarn.lock README.md package.json
    mkdir $out/bin
    mv * $out/lib/node_modules/yarn-lock-converter/

    makeWrapper ${lib.getExe nodejs} $out/bin/yarn-lock-converter \
      --add-flags "$out/lib/node_modules/yarn-lock-converter/index.js"

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = yarn-lock-converter;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Converts modern Yarn v2+ yarn.lock files into a Yarn v1 format";
    homepage = "https://github.com/VHT/yarn-lock-converter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
    mainProgram = "yarn-lock-converter";
  };
})
