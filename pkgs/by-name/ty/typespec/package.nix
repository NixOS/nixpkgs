{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  nodejs,
  pnpm_9,
  testers,
}:

let
  workspace = "compiler...";
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "typespec";
  version = "0.64.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "typespec";
    tag = "typespec@${finalAttrs.version}";
    hash = "sha256-zZTZdnmRTjhnoz/5JHnn4h/YlMpXF/I7o1mDeiRVPUA=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_9.configHook
  ];

  pnpmWorkspaces = [ workspace ];
  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    hash = "sha256-W8m6ibiy9Okga0qWpZWDYklXAwpHwk85Q6UTaFJhDrU=";
  };

  postPatch = ''
    # `fetchFromGitHub` doesn't clone via git and thus installing would otherwise fail.
    substituteInPlace packages/compiler/scripts/generate-manifest.js \
      --replace-fail 'execSync("git rev-parse HEAD").toString().trim()' '"${finalAttrs.src.rev}"'
  '';

  buildPhase = ''
    runHook preBuild

    pnpm -r --filter ${workspace} build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/typespec/packages/compiler"
    cp -r --parents \
      node_modules \
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
    extraArgs = [ ''--version-regex=typespec@(\d+\.\d+\.\d+)'' ];
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
    changelog = "https://github.com/microsoft/typespec/releases/tag/typespec@${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ paukaifler ];
    mainProgram = "tsp";
  };
})
