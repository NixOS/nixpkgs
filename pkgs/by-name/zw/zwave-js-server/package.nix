{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-server";
    rev = version;
    hash = "sha256-PZmIpGcNxjZ5q7rnYj2SdtxCO7SyjWd5QFl+JT89KDU=";
  };

  npmDepsHash = "sha256-CIVGcz8K0kTfcJXaTO7SClt72AhRx1rZUXQgTm+aFdk=";

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
