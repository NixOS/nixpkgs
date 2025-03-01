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
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "webpack";
    repo = "webpack-cli";
    tag = "webpack-cli@${finalAttrs.version}";
    hash = "sha256-teQWaWWt3rKHEVbj3twt8WQXQO9HuzIBNuvFUfRmxqY=";
  };

  yarnKeepDevDeps = true;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = finalAttrs.src + "/yarn.lock";
    hash = "sha256-iYyH1/ZyNKq4MqMcCl7y5WvDnuGnRY0sj8hHsQhe7z4=";
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

  # Removes dangling symlinks that are created as part of the `yarn pack` process.
  # They are not needed at runtime, so it's safe to remove them.
  postInstall = ''
    rm -rf $out/lib/node_modules/webpack-cli/node_modules/{.bin,webpack-cli,create-new-webpack-app,@webpack-cli}
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
