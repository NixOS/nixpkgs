{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-server";
    rev = version;
    hash = "sha256-BX6q7rcw4ib+JUWj4Nuh2OF9E1xwbaa7GFleaQ6NSqI=";
  };

  npmDepsHash = "sha256-aauTtyRgz2XJYMMMvW2tSPeZPSVRjOJG3xBR7MuSLME=";

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
