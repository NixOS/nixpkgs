{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  npm-lockfile-fix,
  textlint,
  textlint-rule-preset-ai-writing,
}:

buildNpmPackage rec {
  pname = "textlint-rule-preset-ai-writing";
  version = "1.6.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "textlint-ja";
    repo = "textlint-rule-preset-ai-writing";
    tag = "v${version}";
    hash = "sha256-vRGmF1H8VFoX2TPlj6miNH73FuCxxmDSUc+2zdd4al0=";
    # Upstream lockfile is missing `resolved` URLs for hundreds of packages,
    # which breaks the offline npm cache. Re-resolve them at fetch time.
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-K4Iq1YE4unR/3uuuZFUFXI6xzCN0ngeb1FNOLKPqdlk=";

  # The upstream `prepare` script runs `git config`, which fails in the
  # sandbox.
  npmFlags = [ "--ignore-scripts" ];

  # Upstream npm name is scoped (@textlint-ja/...), but textlint's resolver
  # via testPackages looks up the unscoped name. Install under the unscoped
  # path so `textlint --preset ai-writing` resolves it.
  dontNpmInstall = true;
  installPhase = ''
    runHook preInstall

    npm prune --omit=dev --ignore-scripts
    mkdir -p $out/lib/node_modules/textlint-rule-preset-ai-writing
    cp -r . $out/lib/node_modules/textlint-rule-preset-ai-writing

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-preset-ai-writing;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint preset that detects AI-style Japanese writing patterns";
    homepage = "https://github.com/textlint-ja/textlint-rule-preset-ai-writing";
    changelog = "https://github.com/textlint-ja/textlint-rule-preset-ai-writing/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paveg ];
  };
}
