{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs-slim,
  pnpm_9,
  versionCheckHook,
  runCommand,
  textlint,
  textlint-plugin-latex2e,
  textlint-rule-abbr-within-parentheses,
  textlint-rule-alex,
  textlint-rule-common-misspellings,
  textlint-rule-diacritics,
  textlint-rule-en-max-word-count,
  textlint-rule-max-comma,
  textlint-rule-no-start-duplicated-conjunction,
  textlint-rule-period-in-list-item,
  textlint-rule-preset-ja-spacing,
  textlint-rule-preset-ja-technical-writing,
  textlint-rule-prh,
  textlint-rule-stop-words,
  textlint-rule-terminology,
  textlint-rule-unexpanded-acronym,
  textlint-rule-write-good,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "textlint";
  version = "15.2.1";

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xjtmYz+O+Sn697OrBkPddv1Ma5UsOkO5v4SGlhsaYWA=";
  };

  patches = [
    # The upstream lockfile contains "overrides" configuration that conflicts with Nix's build environment.
    # We remove these overrides to allow pnpm to install dependencies without modifying the lockfile,
    # which would break the reproducible build process.
    #
    # Without this patch, pnpm fails with:
    # ERR_PNPM_LOCKFILE_CONFIG_MISMATCH Cannot proceed with the frozen installation. The current "overrides" configuration doesn't match the value found in the lockfile
    # Update your lockfile using "pnpm install --no-frozen-lockfile"
    # ERROR: pnpm failed to install dependencies
    ./remove-overrides.patch
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    fetcherVersion = 1;
    hash = "sha256-TyKtH4HjCDTydVd/poG05Yh5nRSfcrSPzFLEE3Oq2uo=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs-slim
    pnpm_9.configHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm --filter textlint... build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/node_modules}

    rm -r node_modules
    rm -r packages/textlint/node_modules
    rm -r packages/@textlint/**/node_modules
    pnpm install --offline --ignore-scripts --frozen-lockfile --prod --filter textlint...

    cp -r packages/{textlint,@textlint} $out/lib/node_modules
    cp -r node_modules/.pnpm $out/lib/node_modules

    makeWrapper "${lib.getExe nodejs-slim}" "$out/bin/textlint" \
      --add-flags "$out/lib/node_modules/textlint/bin/textlint.js"

    # Remove dangling symlinks to packages we didn't copy to $out
    find $out/lib/node_modules/.pnpm -type l -exec test ! -e {} \; -delete

    # Remove test directories recursively
    find $out/lib/node_modules -type d -name "test" -exec rm -rf {} +

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    withPackages =
      ps:
      runCommand "textlint-with-packages" { nativeBuildInputs = [ makeWrapper ]; } ''
        makeWrapper ${textlint}/bin/textlint $out/bin/textlint \
          --set NODE_PATH ${lib.makeSearchPath "lib/node_modules" ps}
      '';

    testPackages =
      {
        rule,
        testFile,
        pname ? rule.pname,
        plugin ? null,
      }:
      let
        ruleName = lib.removePrefix "textlint-rule-" rule.pname;
        isPreset = lib.hasPrefix "preset-" ruleName;
        ruleName' = lib.removePrefix "preset-" ruleName;
        pluginName = lib.removePrefix "textlint-plugin-" plugin.pname;
        args =
          "${testFile} ${if isPreset then "--preset" else "--rule"} ${ruleName'}"
          + lib.optionalString (plugin != null) " --plugin ${pluginName}";
      in
      {
        "${pname}-test" =
          runCommand "${pname}-test"
            {
              nativeBuildInputs = [
                (textlint.withPackages [
                  rule
                  plugin
                ])
              ];
            }
            ''
              grep ${ruleName'} <(textlint ${args}) > $out
            '';
      };

    tests = lib.mergeAttrsList (
      map (package: package.tests) [
        textlint-plugin-latex2e
        textlint-rule-abbr-within-parentheses
        textlint-rule-alex
        textlint-rule-common-misspellings
        textlint-rule-diacritics
        textlint-rule-en-max-word-count
        textlint-rule-max-comma
        textlint-rule-no-start-duplicated-conjunction
        textlint-rule-period-in-list-item
        textlint-rule-preset-ja-spacing
        textlint-rule-preset-ja-technical-writing
        textlint-rule-prh
        textlint-rule-stop-words
        textlint-rule-terminology
        textlint-rule-unexpanded-acronym
        textlint-rule-write-good
      ]
    );
  };

  meta = {
    description = "Pluggable natural language linter for text and markdown";
    homepage = "https://github.com/textlint/textlint";
    changelog = "https://github.com/textlint/textlint/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "textlint";
    platforms = nodejs-slim.meta.platforms;
  };
})
