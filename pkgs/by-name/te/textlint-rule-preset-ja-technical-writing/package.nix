{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-preset-ja-technical-writing,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-ja-technical-writing";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-ja-technical-writing";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8KoP/JagMf2kFxz8hr9e0hJH7yPukRURb48v0nPkC/8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-jm+8XK1E60D1AgYBnlKL0fkAWnn68z2PhCK7T/XbUgk=";
  };

  nativeBuildInputs = [
    nodejs
    fixup-yarn-lock
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

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    yarn --offline --production install
    mkdir -p $out/lib/node_modules/textlint-rule-preset-ja-technical-writing
    cp -r . $out/lib/node_modules/textlint-rule-preset-ja-technical-writing

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-preset-ja-technical-writing;
    testFile = ./test.md;
  };

  meta = {
    description = "技術文書向けのtextlintルールプリセット";
    homepage = "https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing";
    changelog = "https://github.com/textlint-ja/textlint-rule-preset-ja-technical-writing/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
