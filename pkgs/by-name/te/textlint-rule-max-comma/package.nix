{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-max-comma,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-max-comma";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "textlint-rule";
    repo = "textlint-rule-max-comma";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Sf7ehhEOcy1HdgnIra8darkucF6RebQQV/NfJtft/DA=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-jSsVQhvmc5mJ1gh6I5UaLvdz+HpaXI0fXFX0KCh01/c=";
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
    mkdir -p $out/lib/node_modules/textlint-rule-max-comma
    cp -r . $out/lib/node_modules/textlint-rule-max-comma/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-max-comma;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule is that limit maximum comma(,) count of sentence";
    homepage = "https://github.com/textlint-rule/textlint-rule-max-comma";
    changelog = "https://github.com/textlint-rule/textlint-rule-max-comma/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    platforms = textlint.meta.platforms;
  };
})
