{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "1.34.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = pname;
    rev = version;
    hash = "sha256-aTUV9FYE4m/f7rGv7BBFNzCVQpSO9vK1QkeofnMnbzM=";
  };

  npmDepsHash = "sha256-Jne4vzPcNNfHO1LQa609Jdv22Nh3md9KfBXuQoILpbY=";

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
