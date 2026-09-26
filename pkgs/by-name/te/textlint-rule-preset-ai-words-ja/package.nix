{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_10,
  nodejs,
  textlint,
  textlint-rule-preset-ai-words-ja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint-rule-preset-ai-words-ja";
  version = "1.2.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "p1ass";
    repo = "textlint-rule-preset-ai-words-ja";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0QgNPVyheFdPLCLq6JJy5AFIJ5txr1TOvzJ2VFC2C0I=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-azyV6f7aha1dS0bTTNU5rwzKxRpYaARNVDVJKbMA2sM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_10
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pnpm install --offline --frozen-lockfile --ignore-scripts --prod
    mkdir -p $out/lib/node_modules/textlint-rule-preset-ai-words-ja
    cp -r lib node_modules package.json $out/lib/node_modules/textlint-rule-preset-ai-words-ja

    runHook postInstall
  '';

  passthru = {
    tests = textlint.testPackages {
      rule = textlint-rule-preset-ai-words-ja;
      testFile = ./test.md;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Textlint preset that detects words and phrases commonly found in AI-generated Japanese";
    homepage = "https://github.com/p1ass/textlint-rule-preset-ai-words-ja";
    changelog = "https://github.com/p1ass/textlint-rule-preset-ai-words-ja/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ airrnot ];
    platforms = textlint.meta.platforms;
  };
})
