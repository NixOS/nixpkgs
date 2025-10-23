{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tailwindcss-language-server";
  version = "0.14.28";

  src = fetchFromGitHub {
    owner = "tailwindlabs";
    repo = "tailwindcss-intellisense";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jds6Wq4rcR4wXonZ1v9JITiEc4gflT0sTc3KUSBCMFc=";
  };

  pnpmDeps = pnpm_9.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 1;
    hash = "sha256-1F4DeqJWJs3L1hDzNn7PJr9sSBv2TcN8QfV8/pwAKuU=";
  };

  nativeBuildInputs = [
    pnpm_9.configHook
  ];

  buildInputs = [
    nodejs
  ];

  pnpmWorkspaces = [
    "@tailwindcss/language-server..."
  ];

  # Must build the "@tailwindcss/language-service" package. Dependency is linked via workspace by "pnpm"
  # https://github.com/tailwindlabs/tailwindcss-intellisense/blob/v0.14.24/pnpm-lock.yaml#L71
  buildPhase = ''
    runHook preBuild

    pnpm --filter "@tailwindcss/language-server..." build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/tailwindcss-language-server}
    cp -r {packages,node_modules} $out/lib/tailwindcss-language-server
    chmod +x $out/lib/tailwindcss-language-server/packages/tailwindcss-language-server/bin/tailwindcss-language-server
    ln -s $out/lib/tailwindcss-language-server/packages/tailwindcss-language-server/bin/tailwindcss-language-server $out/bin/tailwindcss-language-server

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tailwind CSS Language Server";
    homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
    changelog = "https://github.com/tailwindlabs/tailwindcss-intellisense/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    mainProgram = "tailwindcss-language-server";
    platforms = nodejs.meta.platforms;
  };
})
