{ lib
, buildNpmPackage
, fetchFromGitHub
, nixosTests
}:

buildNpmPackage rec {
  pname = "zwave-js-server";
  version = "1.40.2";

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = pname;
    rev = version;
    hash = "sha256-+S6sMJKmvi5P7eDEWtimArY1W/5IABl/cZkTqhDORgc=";
  };

  npmDepsHash = "sha256-HfxYR62r0D0LTmj4Lb+dCvD4tdpE8b7nmk5wki7vEM8=";

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
