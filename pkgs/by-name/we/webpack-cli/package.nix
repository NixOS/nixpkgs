{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  nodejs,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "webpack-cli";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "webpack";
    repo = "webpack-cli";
    rev = "refs/tags/webpack-cli@${finalAttrs.version}";
    hash = "sha256-OjehyUw54n7/CKbDTVFCtcUp88tJCLUlBCJBQRXoyZM=";
  };

  yarnKeepDevDeps = true;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-+SntrxvFoReQXqyFqnCRCx3nftzcNioQCw6IHe8GztI=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    yarnBuildHook
    yarnInstallHook
    # Needed for executing package.json scripts
    nodejs
  ];

  preInstall = ''
    cp -r node_modules/* packages/webpack-cli/node_modules/
    cp yarn.lock packages/webpack-cli/yarn.lock
    cd packages/webpack-cli
  '';

  postFixup = ''
    mv $out/bin/webpack-cli $out/bin/webpack
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "webpack-cli@";
  };

  meta = {
    changelog = "https://github.com/webpack/webpack-cli/blob/webpack-cli%2540${finalAttrs.version}/CHANGELOG.md";
    description = "Webpack's Command Line Interface";
    homepage = "https://webpack.js.org/api/cli/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "webpack";
  };
})
