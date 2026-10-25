{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  makeWrapper,
  nodejs,
  pnpm_12,
  pnpmBuildHook,
  pnpmConfigHook,
  replaceVars,
  testers,
  typescript_5,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "typescript-language-server";
  version = "6.0.2";

  src = fetchFromGitHub {
    owner = "typescript-language-server";
    repo = "typescript-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3wZYxzN0yGmofpufw4IjPkQGQe70U58ZZ9zrqamqe7s=";
  };

  patches = [
    (replaceVars ./default-fallbackTsserverPath.diff {
      typescript = "${typescript_5}/lib/node_modules/typescript/lib/tsserver.js";
    })
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 4;
    hash = "sha256-xR/EF60lVBsITKgH7wCM2wHM46PFQevD51KfCENSUH4=";
  };

  nativeBuildInputs = [
    makeWrapper
    nodejs
    pnpm_12
    pnpmBuildHook
    pnpmConfigHook
  ];

  installPhase = ''
    runHook preInstall

    # The build is a self-contained bundle: there are no runtime dependencies.
    mkdir -p "$out/lib"
    cp lib/cli.mjs "$out/lib"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/typescript-language-server" \
      --add-flags "$out/lib/cli.mjs"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/typescript-language-server/typescript-language-server/releases/tag/v${finalAttrs.version}";
    description = "Language Server Protocol implementation for TypeScript using tsserver";
    homepage = "https://github.com/typescript-language-server/typescript-language-server";
    license = with lib.licenses; [
      asl20
      mit
    ];
    mainProgram = "typescript-language-server";
    maintainers = with lib.maintainers; [ marcel ];
  };
})
