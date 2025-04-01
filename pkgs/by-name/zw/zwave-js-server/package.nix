{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-server";
    rev = version;
    hash = "sha256-vY/afOza0ewOqlhbp6uMf/mw9nvQLN0lEFmHekxpJVA=";
  };

  npmDepsHash = "sha256-HgXFFA1aa25vRpw4ujj6aeIX75soDYv3TaM5bQOfEv4=";

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
