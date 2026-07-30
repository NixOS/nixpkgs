{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  nix-update-script,

  # build-time
  makeBinaryWrapper,
  nodejs,
  pnpmBuildHook,
  pnpmConfigHook,
  pnpm_10,

  chromium,
  defaultBrowser ? chromium,
}:

let
  pnpm = pnpm_10;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "vivliostyle";
  version = "11.1.0";

  src = fetchFromGitHub {
    owner = "vivliostyle";
    repo = "vivliostyle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rbb/av3amlLit7OjTc+S/pf1SrxEnsENQOArgnc7k3s=";
  };

  patches = [
    ./0001-allow-specifying-browser-path-via-env-var.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-WPTCLAEWmD1TY84281TJCzp+mcjMFM5Xwf02s7U+M4U=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmBuildHook
    pnpmConfigHook
  ];

  pnpmBuildFlags = [
    "--mode"
    "production"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    mv {node_modules,dist,examples,packages,package.json} $out/lib

    runHook postInstall
  '';

  postFixup = ''
    chmod +x $out/lib/dist/cli.js
    patchShebangs $out/usr/lib/dist/cli.js

    makeWrapper $out/lib/dist/cli.js $out/bin/vivliostyle \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set VIVLIOSTYLE_BROWSER_PATH ${lib.getExe defaultBrowser}

    ln -s $out/bin/vivliostyle $out/bin/vs
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "CLI tool for typesetting HTML and Markdown documents";
    longDescription = ''
      Vivliostyle is a CSS typesetting ecosystem for creating beautifully
      formatted documents using web technologies.
    '';
    homepage = "https://github.com/vivliostyle/vivliostyle-cli";
    changelog = "https://github.com/vivliostyle/vivliostyle-cli/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    mainProgram = "vivliostyle";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
