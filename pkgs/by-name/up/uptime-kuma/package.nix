{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs,
  nixosTests,
}:

buildNpmPackage (finalAttrs: {
  pname = "uptime-kuma";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    tag = finalAttrs.version;
    hash = "sha256-zW5sl1g96PvDK3S6XhJ6F369/NSnvU9uSQORCQugfvs=";
  };

  npmDepsHash = "sha256-EmSZJUbtD4FW7Rzdpue6/bV8oZt7RUL11tFBXGJQthg=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
  ];

  postInstall = ''
    cp -r dist $out/lib/node_modules/uptime-kuma/

    # remove references to nodejs source
    rm -r $out/lib/node_modules/uptime-kuma/node_modules/@louislam/sqlite3/build-tmp-napi-v*
  '';

  postFixup = ''
    makeWrapper ${nodejs}/bin/node $out/bin/uptime-kuma-server \
      --add-flags $out/lib/node_modules/uptime-kuma/server/server.js \
      --chdir $out/lib/node_modules/uptime-kuma
  '';

  passthru.tests.uptime-kuma = nixosTests.uptime-kuma;

  meta = {
    description = "Fancy self-hosted monitoring tool";
    mainProgram = "uptime-kuma-server";
    homepage = "https://github.com/louislam/uptime-kuma";
    changelog = "https://github.com/louislam/uptime-kuma/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ julienmalka ];
    # FileNotFoundError: [Errno 2] No such file or directory: 'xcrun'
    broken = stdenv.hostPlatform.isDarwin;
  };
})
