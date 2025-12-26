{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zashboard";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pqtKn0zfHfWS8bDM/IhChCu3MGVIt/oEfhpp+4j5UG4=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-3SJv/cO7sqwrVe8Im3C6NOYpfDnQfonWlVt3TOteWn4=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Dashboard Using Clash API";
    homepage = "https://github.com/Zephyruso/zashboard";
    changelog = "https://github.com/Zephyruso/zashboard/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
})
