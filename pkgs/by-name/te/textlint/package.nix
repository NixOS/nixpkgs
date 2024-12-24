{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  autoconf,
  automake,
  makeWrapper,
  python311,
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
  textlint-rule-preset-ja-technical-writing,
  textlint-rule-prh,
  textlint-rule-stop-words,
  textlint-rule-terminology,
  textlint-rule-unexpanded-acronym,
  textlint-rule-write-good,
}:

buildNpmPackage rec {
  pname = "textlint";
  version = "14.3.0";

  src = fetchFromGitHub {
    owner = "textlint";
    repo = "textlint";
    rev = "refs/tags/v${version}";
    hash = "sha256-FbPJr7oTsU7WC5RTXyG7X5d0KPJJqRbjGwM/F023Cx8=";
  };

  patches = [
    # this package uses lerna and requires building many workspaces.
    # this patch removes unnecessary workspaces,
    # reducing package size and build time.
    ./remove-workspaces.patch
  ];

  npmDepsHash = "sha256-l+1JntqIPttuYXKsVEdJOB1qQfsoheZk+7Z7OJ67z5E=";

  nativeBuildInputs =
    [
      autoconf
      automake
    ]
    ++ lib.optionals (stdenv.hostPlatform.system == "aarch64-linux") [
      # File "/build/source/node_modules/node-gyp/gyp/gyp_main.py", line 42, in <module>
      # npm error ModuleNotFoundError: No module named 'distutils'
      python311
    ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}

    npm prune --omit=dev --no-save
    rm -r node_modules/.cache
    rm -r packages/textlint-{scripts,tester}
    rm -r packages/@textlint/*/test

    cp -r node_modules $out/lib
    cp -r packages $out/lib
    ln -s $out/lib/node_modules/textlint/bin/textlint.js $out/bin/textlint

    runHook postInstall
  '';

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
    changelog = "https://github.com/textlint/textlint/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "textlint";
  };
}
