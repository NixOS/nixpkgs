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
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "typescript-language-server";
    repo = "typescript-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6F2TNDEDi1sSmAPik1ULNp2qB6ZBPhqmFhaJHvQQm38=";
  };

  patches = [
    (replaceVars ./default-fallbackTsserverPath.diff {
      typescript = "${typescript_5}/lib/node_modules/typescript/lib/tsserver.js";
    })
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-kRIlCQLO8GDeuoxNrmYSHi+jJjCXFz9MXrErPdp8Ekg=";
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
