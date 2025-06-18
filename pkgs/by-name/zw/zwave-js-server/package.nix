{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-server";
    rev = version;
    hash = "sha256-wIWpVFeo5oy7Fqiu7P9ifEhK04XKw7F8gHIOEwKNxsQ=";
  };

  npmDepsHash = "sha256-Px8Hs6Nol3fYvLPWFv+RK2ltqFN/hAxtuGtR3dA+4yI=";

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
