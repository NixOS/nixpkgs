{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_9,
  nodejs,
  makeWrapper,
  callPackage,
  nixosTests,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "your_spotify_server";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "Yooooomi";
    repo = "your_spotify";
    tag = finalAttrs.version;
    hash = "sha256-zyvTahfOq7KXgVqD178hrlqO7YjsjLyuw+pm6PMhJt0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-KI5ZFU8u1R4QKTXn6mGVi+ziAocgOyyutKqmUOIn+dI=";
  };

  nativeBuildInputs = [
    makeWrapper
    pnpmConfigHook
    pnpm_9
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    pushd ./apps/server/
    pnpm run build
    popd
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/your_spotify
    cp -r apps/server/build $out/share/your_spotify/
    mkdir -p $out/bin
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_migrate" \
      --add-flags "$out/share/your_spotify/build/index.js" --add-flags "--migrate"
    makeWrapper ${lib.escapeShellArg (lib.getExe nodejs)} "$out/bin/your_spotify_server" \
      --add-flags "$out/share/your_spotify/build/index.js"

    runHook postInstall
  '';

  passthru = {
    client = callPackage ./client.nix {
      inherit (finalAttrs)
        src
        version
        pnpmDeps
        meta
        ;
    };
    tests = {
      inherit (nixosTests) your_spotify;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/Yooooomi/your_spotify";
    changelog = "https://github.com/Yooooomi/your_spotify/releases/tag/${finalAttrs.version}";
    description = "Self-hosted application that tracks what you listen and offers you a dashboard to explore statistics about it";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ patrickdag ];
    mainProgram = "your_spotify_server";
  };
})
