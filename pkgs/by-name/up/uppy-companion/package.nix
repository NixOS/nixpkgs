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

    mkdir -p $out/lib/packages/@uppy
    mkdir $out/bin
    mv packages/@uppy/companion $out/lib/packages/@uppy/companion
    # Remove extra files
    rm -rf $out/lib/packages/@uppy/companion/{*.md,LICENSE,Makefile,.*ignore,infra/,output/,test/,__mocks__/,*/json}
    # Remove dev dependencies
    rm -rf $out/lib/packages/@uppy/companion/node_modules/{.bin,webpack*,update*,tyepscript,jest*,eslint*,{@,}esbuild,{@,}rollup,terser,@types,execa,http-proxy,nock,supertest,vite*}

    # Link final binary
    ln -s $out/lib/packages/@uppy/companion/bin/companion $out/bin/companion

    patchShebangs $out/bin/companion

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
