{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,

  # build-time
  makeBinaryWrapper,
  nodejs,
  pnpmBuildHook,
  pnpmConfigHook,
  pnpm_12,

  versionCheckHook,
  nix-update-script,

  chromium,
  defaultBrowser ? chromium,
}:

let
  pnpm = pnpm_12;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "vivliostyle";
  version = "11.5.0";

  src = fetchFromGitHub {
    owner = "vivliostyle";
    repo = "vivliostyle-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Mruulx2Zz98Xgqs452DeNu+OADTmyyedYt82bzilyg4=";
  };

  patches = [
    ./0001-allow-specifying-browser-path-via-env-var.patch
  ];

  __structuredAttrs = true;
  strictDeps = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-AK1Q6Q7OyRDWO87WhIQepMAJaCVihocnAPIpF4x+waw=";
  };

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
    pnpm
    pnpmBuildHook
    pnpmConfigHook
  ];

  buildInputs = [
    nodejs
  ];

  pnpmBuildFlags = [
    "--mode"
    "production"
  ];

  preBuild = ''
    # delete local pnpm so the build uses pkgs.pnpm
    find . -name pnpm -path '*/.bin/pnpm' -delete
  '';

  preInstall = ''
    # `pnpm prune` doesn't support monorepos, and with pnpm 12 it also tries
    # to verify the lockfile against supply-chain policies over the network.
    # Reinstall production dependencies only instead.
    rm -rf node_modules
    pnpm install \
      --config.trust-lockfile=true \
      --frozen-lockfile \
      --ignore-scripts \
      --offline \
      --prod

    # remove broken symlinks
    find . -xtype l -delete
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    mv {node_modules,dist,examples,packages,package.json} $out/lib

    runHook postInstall
  '';

  postFixup = ''
    chmod +x $out/lib/dist/cli.js
    patchShebangs $out/lib/dist/cli.js

    makeWrapper $out/lib/dist/cli.js $out/bin/vivliostyle \
      --prefix PATH : ${lib.makeBinPath [ nodejs ]} \
      --set VIVLIOSTYLE_BROWSER_PATH ${lib.getExe defaultBrowser}

    ln -s $out/bin/vivliostyle $out/bin/vs
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

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
