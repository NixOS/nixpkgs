{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  nodejs,
  npmHooks,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vim-language-server";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "iamcco";
    repo = "vim-language-server";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NfBKNCTvCMIJrSiTlCG+LtVoMBMdCc3rzpDb9Vp2CGM=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-mo8urQaWIHu33+r0Y7mL9mJ/aSe/5CihuIetTeDHEUQ=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    # Needed for executing package.json scripts
    nodejs
    npmHooks.npmInstallHook
  ];
  # https://stackoverflow.com/a/69699772/4935114
  preBuild = ''
    export NODE_OPTIONS=--openssl-legacy-provider
  '';
  # Needed ever since noBrokenSymlinks was introduced
  postInstall = ''
    rm $out/lib/node_modules/vim-language-server/node_modules/.bin/node-which
  '';

  meta = {
    description = "VImScript language server, LSP for vim script";
    homepage = "https://github.com/iamcco/vim-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "vim-language-server";
  };
})
