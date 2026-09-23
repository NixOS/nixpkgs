{
  lib,
  stdenv,
  nodejs,
  fetchFromGitHub,
  substitute,
  yarn-berry_4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "uppy-companion";
  version = "6.2.0";

  src = fetchFromGitHub {
    owner = "transloadit";
    repo = "uppy";
    tag = "@uppy/companion@${finalAttrs.version}";
    hash = "sha256-4Xbw4d0SaLPk4mmvG9QWkUuVX/SM1SmGtuaK85rLihU=";

    # Remove after upstream updates to Yarn 4.15
    # https://github.com/transloadit/uppy/blob/main/package.json#L38
    postFetch = ''
      cd $out
      patch -p1 < ${
        (substitute {
          src = ./yarn-fix.patch;
          substitutions = [
            "--replace-fail"
            "YARN_LOCKFILE_VERSION_PLACEHOLDER"
            yarn-berry_4.lockfileVersion
          ];
        })
      }
    '';
  };

  nativeBuildInputs = [
    nodejs
    yarn-berry_4.yarnBerryConfigHook
    yarn-berry_4
  ];

  buildInputs = [
    nodejs
  ];

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-MQTaNbeJuvWDtRajJQYRtuxiMrLGKtlasyB6sKeOIgs=";
  };

  buildPhase = ''
    runHook preBuild

    yarn workspace '@uppy/companion' run build
    yarn workspace '@uppy/companion' run test

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    export yarnTmpDir=$(mktemp -d)
    export yarnPack=$yarnTmpDir/yarn-pack.tgz

    mkdir -p $out/lib/node_modules/@uppy/companion $out/bin

    pushd packages/@uppy/companion

    yarn pack -o $yarnPack
    tar xvf $yarnPack -C $out/lib/node_modules/@uppy/companion --strip-components 1 package/

    rm -rf node_modules
    yarn workspaces focus --production
    find node_modules -maxdepth 1 -type d -empty -delete
    cp -r node_modules $out/lib/node_modules/@uppy/companion/node_modules
    popd

    ln -s $out/lib/node_modules/@uppy/companion/bin/companion $out/bin/companion
    runHook postInstall
  '';

  updateScript = ./update.sh;

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    changelog = "https://github.com/transloadit/uppy/releases/tag/%40uppy%2Fcompanion%40${finalAttrs.version}";
    description = "Server integration for Uppy file uploader";
    homepage = "https://uppy.io/";
    license = lib.licenses.mit;
    mainProgram = "companion";
    maintainers = [ ];
  };
})
