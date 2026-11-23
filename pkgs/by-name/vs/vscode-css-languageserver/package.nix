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
  typescript_7,
  nix-update-script,
}:

let
  pnpm = pnpm_12;
  typescript = typescript_7;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vscode-css-languageserver";
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

  pnpmWorkspaces = [ "vscode-css-languageserver" ];

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
    hash = "sha256-GbTYtIdx+NpR/QD+v7KH3G68JGDzzUKo/Ppl1dn30zw=";
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

  env.pnpm_config_virtual_store_dir = "extensions/css-language-features/server/node_modules/.pnpm";

  buildPhase = ''
    runHook preBuild

    pushd extensions/css-language-features/server
    tsc -p . \
      --typeRoots ./node_modules/@types \
      --module nodenext \
      --moduleResolution nodenext
    popd

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    rm -rf node_modules extensions/css-language-features/server/node_modules
    pnpm install \
      --filter=vscode-css-languageserver \
      --prod \
      --offline \
      --ignore-scripts \
      --frozen-lockfile

    mkdir -p $out/lib/node_modules/vscode-css-languageserver
    cp -r extensions/css-language-features/server/{package.json,out,node_modules} \
      $out/lib/node_modules/vscode-css-languageserver

    makeBinaryWrapper ${lib.getExe nodejs} $out/bin/vscode-css-languageserver \
      --add-flags $out/lib/node_modules/vscode-css-languageserver/out/node/cssServerMain.js
    ln -s $out/bin/vscode-css-languageserver $out/bin/vscode-css-language-server

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CSS language server";
    homepage = "https://github.com/microsoft/vscode/tree/${finalAttrs.src.tag}/extensions/css-language-features/server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ryota2357 ];
    mainProgram = "vscode-css-languageserver";
  };
})
