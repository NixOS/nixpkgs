{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-unexpanded-acronym,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-unexpanded-acronym";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-unexpanded-acronym";
    tag = finalAttrs.version;
    hash = "sha256-oUOofYfdENRQnwmBDADQgA1uGtRirqqGg8T+QA0LCXY=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-90ZONfn7CnrCsYGliF+c7Ss+SgVmaCYnaVdq3s1HdJU=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-unexpanded-acronym
    cp -r . $out/lib/node_modules/textlint-rule-unexpanded-acronym/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-unexpanded-acronym;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule that check unexpanded acronym";
    homepage = "https://github.com/textlint-rule/textlint-rule-unexpanded-acronym";
    changelog = "https://github.com/textlint-rule/textlint-rule-unexpanded-acronym/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
