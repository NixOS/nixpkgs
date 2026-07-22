{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-no-start-duplicated-conjunction,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-no-start-duplicated-conjunction";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-no-start-duplicated-conjunction";
    tag = finalAttrs.version;
    hash = "sha256-DtuCkHy440j2VI/JDJGrW2M8alQ8pxllfIZfB4+9z3U=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-+3SJQgOG5bYSmNWbxsFNEEtKtCg8V04MIk6FhHwOZMo=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-no-start-duplicated-conjunction
    cp -r . $out/lib/node_modules/textlint-rule-no-start-duplicated-conjunction/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-no-start-duplicated-conjunction;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule that check no start with duplicated conjunction";
    homepage = "https://github.com/textlint-rule/textlint-rule-no-start-duplicated-conjunction";
    changelog = "https://github.com/textlint-rule/textlint-rule-no-start-duplicated-conjunction/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
