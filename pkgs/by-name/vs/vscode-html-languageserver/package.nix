{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm_12,
  nodejs,
  jq,
  yq,
  makeBinaryWrapper,
  typescript_5,
  nix-update-script,
}:

let
  pnpm = pnpm_12;
  typescript = typescript_5;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vscode-html-languageserver";
  version = "1.147.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vscode";
    tag = finalAttrs.version;
    hash = "sha256-dojp+ajuGHuRgffwyFzWqWGiXFEXfmtJtAjRWtj33QQ=";
  };

  # pnpm installs the workspace root's dependencies even with `--filter`
  postPatch = ''
    jq 'del(.dependencies, .devDependencies, .optionalDependencies)' package.json > package.json.tmp
    mv package.json.tmp package.json
    yq -i -y --explicit-start 'del(
      .importers["."].dependencies,
      .importers["."].devDependencies,
      .importers["."].optionalDependencies
    )' pnpm-lock.yaml
  '';

  pnpmWorkspaces = [ "vscode-html-languageserver" ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      pnpmWorkspaces
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-PV7RV3NyNETjLZHmCPpu9DRM51uAd2N43k6Ie/g64Bo=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    jq
    yq
    makeBinaryWrapper
    typescript
  ];

  env.pnpm_config_virtual_store_dir = "extensions/html-language-features/server/node_modules/.pnpm";

  # Upstream reads TypeScript's lib .d.ts files from VS Code's extensions/node_modules
  preBuild = ''
    substituteInPlace extensions/html-language-features/server/src/modes/javascriptLibs.ts \
      --replace-fail "'../../node_modules/typescript/lib'" "'node_modules/typescript/lib'"
  '';

  buildPhase = ''
    runHook preBuild

    pushd extensions/html-language-features/server
    ln -s ${typescript}/lib/node_modules/typescript node_modules/typescript
    tsc -p . \
      --typeRoots ./node_modules/@types \
      --moduleResolution bundler
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules extensions/html-language-features/server/node_modules
    pnpm install \
      --filter=vscode-html-languageserver \
      --prod \
      --offline \
      --ignore-scripts \
      --frozen-lockfile

    mkdir -p $out/lib/node_modules/vscode-html-languageserver
    cp -r extensions/html-language-features/server/{package.json,out,lib,node_modules} \
      $out/lib/node_modules/vscode-html-languageserver

    # The server loads TypeScript at runtime for JavaScript in <script>.
    ln -s ${typescript}/lib/node_modules/typescript \
      $out/lib/node_modules/vscode-html-languageserver/node_modules/typescript

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/vscode-html-languageserver \
      --add-flags $out/lib/node_modules/vscode-html-languageserver/out/node/htmlServerMain.js
    ln -s $out/bin/vscode-html-languageserver $out/bin/vscode-html-language-server

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "HTML language server";
    homepage = "https://github.com/microsoft/vscode/tree/${finalAttrs.src.tag}/extensions/html-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "vscode-html-languageserver";
  };
})
