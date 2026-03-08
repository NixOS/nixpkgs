{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pnpm_10,
  pnpm ? pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "zashboard";
  version = "2.7.0";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qEbJ9cqJq5nvsJ0spfdH1Q76Xsr9Rd1TuULX87ZjFJs=";
  };

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-9FLJ16xZZ0Yq9+J9PMYRkjh8b1Zx/vRf0CEnskyi/OA=";
  };

  nativeBuildInputs = [ pnpm ];
  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    changelog = "https://github.com/Zephyruso/zashboard/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
  };
})
