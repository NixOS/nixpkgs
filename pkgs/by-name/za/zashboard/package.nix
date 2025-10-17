{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_9,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zashboard";
  version = "1.103.1";

  src = fetchFromGitHub {
    owner = "Zephyruso";
    repo = "zashboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xZg0ca11TfiB2rRFONDTBv8kX25JR9kSelwPqS/HvhI=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
    nodejs
  ];

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-O4MayQ9r+++0XvRmXnuVnw4nHx66jVahs0sm221wfV0=";
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
