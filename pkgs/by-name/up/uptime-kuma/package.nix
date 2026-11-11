{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nixosTests,
  srcOnly,
}:

buildNpmPackage (finalAttrs: {
  pname = "uptime-kuma";
  version = "2.5.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    tag = finalAttrs.version;
    hash = "sha256-DvvewtonV+0fuv1OgmnPt4Pihw26GVaRBWBMQmkieNI=";
  };

  inherit nodejs;
  npmDepsHash = "sha256-BlfgcvScmHV4weoviotGKB3tCa8mFBeoHYU+OPE/A/Q=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
  ];

  postInstall = ''
    cp -r dist $out/lib/node_modules/uptime-kuma/

    # remove references to nodejs source
    rm -r $out/lib/node_modules/uptime-kuma/node_modules/@louislam/sqlite3/build-tmp-napi-v*
    shopt -s globstar
    rm -r $out/lib/node_modules/uptime-kuma/node_modules/**/{*.target.mk,config.gypi,Makefile,Release/.deps}
    shopt -u globstar
    # remove references to python
    rm -r $out/lib/node_modules/uptime-kuma/node_modules/{node-gyp,.bin/node-gyp}
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/uptime-kuma-server \
      --add-flags $out/lib/node_modules/uptime-kuma/server/server.js \
      --chdir $out/lib/node_modules/uptime-kuma
  '';

  disallowedReferences = [
    (srcOnly nodejs)
    nodejs.python
  ];

  passthru.tests.uptime-kuma = nixosTests.uptime-kuma;

  meta = {
    description = "Fancy self-hosted monitoring tool";
    mainProgram = "uptime-kuma-server";
    homepage = "https://github.com/louislam/uptime-kuma";
    changelog = "https://github.com/louislam/uptime-kuma/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      julienmalka
      felixsinger
    ];
    # FileNotFoundError: [Errno 2] No such file or directory: 'xcrun'
    broken = stdenv.hostPlatform.isDarwin;
  };
})
