{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yamlresume";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "yamlresume";
    repo = "yamlresume";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fMbXo2iv58nOoQdqbJRRuOH6XCfrNUvHmSULGffxDFQ=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-2ACPsh7ly9m8endYRoYgn9lntAo4NDeMdxPNkYhT7a4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild
    pnpm build:prod
    runHook postBuild
  '';

  checkPhase = ''
    pnpm test
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/yamlresume
    cp -R packages $out/lib/yamlresume
    ln -s $out/lib/yamlresume/cli/dist/cli.js $out/bin/yamlresume
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage and version control resumes using YAML";
    homepage = "https://yamlresume.dev/";
    changelog = "https://github.com/yamlresume/yamlresume/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ VZstless ];
    mainProgram = "yamlresume";
  };
})
