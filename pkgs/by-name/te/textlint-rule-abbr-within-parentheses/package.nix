{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-abbr-within-parentheses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-abbr-within-parentheses";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "azu";
    repo = "textlint-rule-abbr-within-parentheses";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-CBrf7WtvywDmtuSyxkDtAyjmrj7KS3TQLSsNfMxeWXw=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-N4tnja6qTo7jtn7Dh4TwBUCUKfbIbHvdZ7aeJcE+NlU=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-abbr-within-parentheses
    cp -r . $out/lib/node_modules/textlint-rule-abbr-within-parentheses/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-abbr-within-parentheses;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule check if write abbreviations within parentheses";
    homepage = "https://github.com/azu/textlint-rule-abbr-within-parentheses";
    changelog = "https://github.com/azu/textlint-rule-abbr-within-parentheses/releases/tag/${lib.removePrefix "refs/tags/" finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
