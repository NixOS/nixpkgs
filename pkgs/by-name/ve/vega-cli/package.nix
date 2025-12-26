{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  pixman,
  cairo,
  pango,
  jq,
}:

buildNpmPackage (finalAttrs: {
  pname = "vega-cli";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "vega";
    repo = "vega";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YO3YzTRNJKDOgCxMXnw2P2d1ZN79Db3//L9iLjDGiyM=";
  };

  postPatch = ''
    # We never need this, so just skip it to save some time while building.
    patchShebangs scripts/postinstall.sh
    substituteInPlace scripts/postinstall.sh \
      --replace-fail "npm run data" "true"

    # Patch lerna.json to not use nx
    mv lerna.json lerna.old.json
    jq '. + {useNx: false}' < lerna.old.json > lerna.json
  '';

  npmDepsHash = "sha256-mBe1fHnhor7ZR8CuRNs1zD7JzaZXZI5VM7mdAieVKqE=";

  npmWorkspace = "vega-cli";

  buildInputs = [
    pixman
    cairo
    pango
  ];

  nativeBuildInputs = [
    pkg-config
    jq
  ];

  buildPhase = ''
    runHook preBuild

    npm run build --scope vega-cli --include-dependencies --stream

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # prune non-prod deps
    npm prune --omit=dev --no-save --workspace vega-cli

    mkdir -p $out/lib/node_modules/vega-cli
    rm -rf packages/**/{test,*.md,.npmignore}
    cp -r ./packages ./node_modules $out/lib/node_modules/vega-cli
    ln -s $out/lib/node_modules/vega-cli/packages/vega-cli/bin $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Command line tools for the Vega visualization grammar";
    homepage = "https://vega.github.io/vega/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
