{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-server";
    rev = version;
    hash = "sha256-U4IF8R8dqgtxlFOQLXIcc8tnSyGzd3iAJym1YGcMi3s=";
  };

  npmDepsHash = "sha256-5WLKQmJwsjFvCp7iZ8O9lphYY6g7YAxy4jbVzvZQ6dY=";

  # For some reason the zwave-js dependency is in devDependencies
  npmFlags = [ "--include=dev" ];

  passthru = {
    tests = {
      inherit (nixosTests) zwave-js;
    };
  };

  meta = {
    changelog = "https://github.com/zwave-js/zwave-js-server/releases/tag/${version}";
    description = "Small server wrapper around Z-Wave JS to access it via a WebSocket";
    license = lib.licenses.asl20;
    homepage = "https://github.com/zwave-js/zwave-js-server";
    maintainers = with lib.maintainers; [ graham33 ];
  };
}
