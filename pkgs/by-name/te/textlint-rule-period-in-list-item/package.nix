{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-period-in-list-item,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-period-in-list-item";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-period-in-list-item";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-hAkueH5q5s0kmvKZiOrCxtfmoHtHH0U8cVLhQ7eoqT0=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-4tVTR/Wpcr/nJrBhqV3AowwcUiFNiuohyKn6yQvorvc=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-period-in-list-item
    cp -r . $out/lib/node_modules/textlint-rule-period-in-list-item/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-period-in-list-item;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule that check with or without period in list item";
    homepage = "https://github.com/textlint-rule/textlint-rule-period-in-list-item";
    changelog = "https://github.com/textlint-rule/textlint-rule-period-in-list-item/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
