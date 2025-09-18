{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  python3,
  nodejs,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "uptime-kuma";
  version = "1.23.16";

  src = fetchFromGitHub {
    owner = "louislam";
    repo = "uptime-kuma";
    rev = version;
    hash = "sha256-+bhKnyZnGd+tNlsxvP96I9LXOca8FmOPhIFHp7ijmyA=";
  };

  npmDepsHash = "sha256-5i1NxwHqOahkioyM4wSu2X5KeMu7CdC4BqoUooAshn4=";

  patches = [
    # Fixes the permissions of the database being not set correctly
    # See https://github.com/louislam/uptime-kuma/pull/2119
    ./fix-database-permissions.patch
  ];

  nativeBuildInputs = [ python3 ];

  CYPRESS_INSTALL_BINARY = 0; # Stops Cypress from trying to download binaries

  postInstall = ''
    cp -r dist $out/lib/node_modules/uptime-kuma/

    # remove references to nodejs source
    rm -r $out/lib/node_modules/uptime-kuma/node_modules/@louislam/sqlite3/build-tmp-napi-v6
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
    changelog = "https://github.com/louislam/uptime-kuma/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ julienmalka ];
    # FileNotFoundError: [Errno 2] No such file or directory: 'xcrun'
    broken = stdenv.hostPlatform.isDarwin;
  };
}
