{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  yarnBuildHook,
  yarnConfigHook,
  textlint,
  textlint-rule-preset-japanese,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-japanese";
  version = "10.0.4";

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-japanese";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i7DVkSLGEVk+asTS2obNtW0OtZq8vPXkwC0JeEsGlh8=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-mFZLBtG3Y/etLGf+dhyPbhxlQnoMhV845AKhaRu8iqk=";
  };

  nativeBuildInputs = [
    nodejs
    yarnBuildHook
    yarnConfigHook
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    yarn install \
      --force \
      --frozen-lockfile \
      --ignore-engines \
      --ignore-platform \
      --ignore-scripts \
      --no-progress \
      --non-interactive \
      --offline \
      --production=true

    mkdir -p $out/lib/node_modules/textlint-rule-preset-japanese
    cp -r . $out/lib/node_modules/textlint-rule-preset-japanese

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-preset-japanese;
    testFile = ./test.md;
  };

  meta = {
    description = "textlint rule preset for Japanese";
    homepage = "https://github.com/textlint-ja/textlint-rule-preset-japanese";
    changelog = "https://github.com/textlint-ja/textlint-rule-preset-japanese/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      takeokunn
    ];
    platforms = textlint.meta.platforms;
  };
})
