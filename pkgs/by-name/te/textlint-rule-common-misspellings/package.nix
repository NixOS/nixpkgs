{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
  textlint-rule-common-misspellings,
}:

# there is no lock file in this package, but it is old and stable enough
# so that we handle dependencies manually
let
  misspellings = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "misspellings";
    version = "1.1.0";

    src = fetchurl {
      url = "https://registry.npmjs.org/misspellings/-/misspellings-${finalAttrs.version}.tgz";
      hash = "sha256-+4QxmGjoF0mBldN4XQMvoK8YDS4PBV9/c+/BPf4FbkM=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/node_modules/misspellings
      cp -r . $out/lib/node_modules/misspellings/

      runHook postInstall
    '';
  });

  textlint-rule-helper = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "textlint-rule-helper";
    version = "2.3.1";

    src = fetchFromGitHub {
      owner = "textlint";
      repo = "textlint-rule-helper";
      rev = "refs/tags/v${finalAttrs.version}";
      hash = "sha256-SVeL/3KC/yazSGsmn5We8fJAuVqfcspzN7i2a4+EOlI=";
    };

    offlineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-UN56VuUHl7aS+QLON8ZROTSCGKKCn/8xuIkR46LyY+U=";
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
      mkdir -p $out/lib/node_modules/textlint-rule-helper
      cp -r . $out/lib/node_modules/textlint-rule-helper/

      runHook postInstall
    '';
  });
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "textlint-rule-common-misspellings";
  version = "1.0.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/textlint-rule-common-misspellings/-/textlint-rule-common-misspellings-${finalAttrs.version}.tgz";
    hash = "sha256-5QVb5T2yGuunNhRQG5brJQyicRRbO8XewzjO2RzN0bI=";
  };

  dontBuild = true;

  buildInputs = [
    misspellings
    textlint-rule-helper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/textlint-rule-common-misspellings/node_modules/textlint-rule-helper
    cp -r ${misspellings}/lib/node_modules/misspellings $out/lib/node_modules/textlint-rule-common-misspellings/node_modules/misspellings
    cp -r ${textlint-rule-helper}/lib/node_modules/textlint-rule-helper/node_modules/* $out/lib/node_modules/textlint-rule-common-misspellings/node_modules
    cp -r ${textlint-rule-helper}/lib/node_modules/textlint-rule-helper/lib $out/lib/node_modules/textlint-rule-common-misspellings/node_modules/textlint-rule-helper/lib
    cp -r ${textlint-rule-helper}/lib/node_modules/textlint-rule-helper/package.json $out/lib/node_modules/textlint-rule-common-misspellings/node_modules/textlint-rule-helper/package.json

    cp -r . $out/lib/node_modules/textlint-rule-common-misspellings/

    runHook postInstall
  '';

  passthru.tests = textlint.testPackages {
    rule = textlint-rule-common-misspellings;
    testFile = ./test.md;
  };

  meta = {
    description = "Textlint rule to check common misspellings";
    homepage = "https://github.com/io-monad/textlint-rule-common-misspellings";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ natsukium ];
    mainProgram = "textlint-rule-common-misspellings";
    platforms = textlint.meta.platforms;
  };
})
