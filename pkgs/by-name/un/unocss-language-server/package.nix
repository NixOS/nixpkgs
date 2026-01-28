{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unocss-language-server";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "xna00";
    repo = "unocss-language-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rRi9JvjljvjBbY6UsH2YzAQcp+Z+MqxK7hhDNkpEANw=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-vGSr+nLtV189QVoe1cKZoX+sUhTlqOe+EgurnXHCILY=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/unocss-language-server}
    cp -r {out,bin,node_modules} $out/lib/unocss-language-server/

    chmod +x $out/lib/unocss-language-server/bin/index.js
    patchShebangs $out/lib/unocss-language-server/bin/index.js
    ln -s $out/lib/unocss-language-server/bin/index.js $out/bin/unocss-language-server

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Language server for UnoCSS";
    homepage = "https://github.com/xna00/unocss-language-server";
    changelog = "https://github.com/xna00/unocss-language-server/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryoppippi ];
    mainProgram = "unocss-language-server";
  };
})
