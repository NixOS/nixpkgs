{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  makeWrapper,
  nodejs,
  yarn,
  yarnBuildHook,
  yarnConfigHook,
  yarnInstallHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yao-pkg";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "yao-pkg";
    repo = "pkg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AQ+PVIWYgrflDsauxCfmvo40imlTAOW3vXhMtN+eKq4=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-7jIrhIuuHSkfQCnjifgYCEIHi169np78NLhuw6iZRyU=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    makeWrapper
    nodejs
    yarn
    yarnBuildHook
    yarnConfigHook
    yarnInstallHook
  ];

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    yarn config --offline set yarn-offline-mirror ${finalAttrs.offlineCache}
    fixup-yarn-lock yarn.lock
    yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
    patchShebangs node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline prepare

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    yarn --offline --production install

    mkdir -p "$out/lib/node_modules/pkg"
    cp -r . "$out/lib/node_modules/pkg"

    makeWrapper "${lib.getExe nodejs}" "$out/bin/pkg" \
      --add-flags "$out/lib/node_modules/pkg/lib-es5/bin.js"

    runHook postInstall
  '';

  meta = {
    description = "Package your Node.js project into an executable";
    longDescription = ''
      This command line interface enables you to package your Node.js project into
      an executable that can be run even on devices without Node.js installed.
      This is also the most active and updated fork of the original vercel/pkg project.
      It packages your Node.js project into standalone executables, making it easy to
      distribute without requiring Node.js to be installed on the target system.
    '';
    mainProgram = "pkg";
    homepage = "https://github.com/yao-pkg/pkg";
    license = lib.licenses.mit;
    inherit (nodejs.meta) platforms;
    maintainers = with lib.maintainers; [ onahp ];
  };
})
