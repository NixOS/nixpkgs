{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
buildNpmPackage (finalAttrs: {
  pname = "zashboard";
  version = "3.17.0";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5CxzST/3vb6YxzvjAJSyDORpW++R2OonTfJUp9trdBc=";
  };

  npmDeps = null;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-UjoY2/cLJ0chdZ2VUq/7KoJXRhLrJAADi8jEYjHKdmw=";
  };

  nativeBuildInputs = [ pnpm ];
  npmConfigHook = pnpmConfigHook;

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "getGitCommitId()" '""'
  '';

  __darwinAllowLocalNetworking = true;

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
