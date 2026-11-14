{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-plugin-html,
  textlint-rule-max-comma,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-plugin-html";
  version = "1.0.1";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint-plugin-html";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/G1broo4QJHYoBXUHZzK8DLDxKFHpHVWDmkEExkFEPk=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-poZsWLtMH6Gy3tcWLhuv5c65AU0KVoMJD62m5r+ZLu4=";
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
    rm -rf test
    mkdir -p $out/lib/node_modules/textlint-plugin-html
    cp -r . $out/lib/node_modules/textlint-plugin-html/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    inherit (textlint-plugin-html) pname;
    rule = textlint-rule-max-comma;
    plugin = textlint-plugin-html;
    testFile = ./test.html;
  };

  meta = {
    description = "Add HTML support for textlint";
    homepage = "https://github.com/textlint/textlint-plugin-html";
    changelog = "https://github.com/textlint/textlint-plugin-html/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ _3w36zj6 ];
    platforms = textlint.meta.platforms;
  };
})
