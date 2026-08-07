{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-write-good,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-write-good";
  version = "2.0.0-unstable-2024-05-02";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-write-good";
    rev = "586afa0989ae9ac8a93436f58a24d99afe1cac21";
    hash = "sha256-ghEmWkwGVvLMy6Gf7IrariDRNfuNBc9EVOQz5w38g0I=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-J02MoKPEYtehQMSaOR1Ytfme1ffgHbQcNnEENeTaxaA=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    nodejs
    yarn
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install
    rm -r test
    mkdir -p $out/lib/node_modules/textlint-rule-write-good
    cp -r . $out/lib/node_modules/textlint-rule-write-good/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-write-good;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to check your English styles with write-good";
    homepage = "https://github.com/textlint-rule/textlint-rule-write-good";
    changelog = "https://github.com/textlint-rule/textlint-rule-write-good/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
