{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "webpack-cli";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "webpack";
    repo = "webpack-cli";
    tag = "webpack-cli@${finalAttrs.version}";
    hash = "sha256-WAfjDPGgoLkwth7UzQpOw44RGf524BysV4i62OiVM28=";
  };

  npmWorkspace = "packages/webpack-cli";

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-UbsO5I4cHFMJ7PX7V2X/r5N0rpPwm+QPCEVhxO/UZHg=";
  npmFlags = [ "--legacy-peer-deps" ];

  # `npmBuildHook` runs the workspace's build script but we don't want that here since it doesn't have that
  dontNpmBuild = true;
  buildPhase = ''
    runHook preBuild
    npm run build
    runHook postBuild
  '';

  postFixup = ''
    ln -s $out/bin/webpack-cli $out/bin/webpack
  '';

  # fix `noBrokenSymlinks` errors
  postInstall = ''
    cp -r ./packages $out/lib/node_modules/webpack-cli-monorepo/packages
    pushd $out/lib/node_modules/webpack-cli-monorepo
    rm -rf node_modules/.bin
    ls -la
    popd
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "webpack-cli@(.*)"
    ];
  };

  meta = {
    changelog = "https://github.com/webpack/webpack-cli/blob/webpack-cli%40${finalAttrs.version}/CHANGELOG.md";
    description = "Webpack's Command Line Interface";
    homepage = "https://webpack.js.org/api/cli/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "webpack";
  };
})
