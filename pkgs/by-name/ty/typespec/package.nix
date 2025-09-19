{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodejs,
  pnpm,
  testers,
}:

let
  workspace = "@typespec/compiler...";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "typespec";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typespec";
    tag = "typespec-stable@${finalAttrs.version}";
    hash = "sha256-huyEQA+XhlGVxnxUzQH1aIZUE4EbCN6HakitzuDyR18=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm.configHook
  ];

  pnpmWorkspaces = [ workspace ];
  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      postPatch
      ;
    fetcherVersion = 1;
    hash = "sha256-/Y7KhdNeyUV2CQQWjhYBDDT24oE6UdBO6HTweUUaNqc=";
  };

  postPatch = ''
    # The `packageManager` attribute matches the version _exactly_, which makes
    # the build fail if it doesn't match exactly.
    substituteInPlace package.json \
      --replace-fail '"packageManager": "pnpm@10.11.0"' '"packageManager": "pnpm"'
    # `fetchFromGitHub` doesn't clone via git and thus installing would otherwise fail.
    substituteInPlace packages/compiler/scripts/generate-manifest.js \
      --replace-fail 'execSync("git rev-parse HEAD").toString().trim()' '"${finalAttrs.src.rev}"'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm -r --filter ${workspace} build

    runHook postBuild
  '';

  preInstall = ''
    # Remove unnecessary files.
    find -name node_modules -type d -exec rm -rf {} \; || true
    pnpm config set hoist=false
    pnpm install --offline --ignore-scripts --frozen-lockfile --filter="@typespec/compiler" --prod --no-optional
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/typespec"
    cp -r --parents \
      node_modules/ \
      package.json \
      packages/compiler/cmd \
      packages/compiler/dist \
      packages/compiler/entrypoints \
      packages/compiler/lib \
      packages/compiler/node_modules \
      packages/compiler/templates \
      packages/compiler/package.json \
      "$out/lib/typespec"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/tsp" \
      --add-flags "$out/lib/typespec/packages/compiler/cmd/tsp.js"
    makeWrapper "${lib.getExe nodejs}" "$out/bin/tsp-server" \
      --add-flags "$out/lib/typespec/packages/compiler/cmd/tsp-server.js"

    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ ''--version-regex=typespec-stable@(\d+\.\d+\.\d+)'' ];
  };

  meta = {
    description = "Language for defining cloud service APIs and shapes";
    longDescription = ''
      TypeSpec is a highly extensible language with primitives that can describe
      API shapes common among REST, OpenAPI, gRPC, and other protocols.

      TypeSpec is excellent for generating many different API description
      formats, client and service code, documentation, and many other assets.
      All this while keeping your TypeSpec definition as a single source of truth.
    '';
    homepage = "https://typespec.io/";
    changelog = "https://github.com/microsoft/typespec/releases/tag/typespec-stable@${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paukaifler ];
    mainProgram = "tsp";
  };
})
