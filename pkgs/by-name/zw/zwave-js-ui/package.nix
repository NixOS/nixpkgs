{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "zwave-js-ui";
<<<<<<< HEAD
  version = "11.9.1";
=======
  version = "11.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "zwave-js";
    repo = "zwave-js-ui";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-skDNRBOffNKa6ZXSIfP8Oip1/dp35a2rtm44D5Q8HS0=";
  };
  npmDepsHash = "sha256-oTJKh+mpwB9m8KXF0CJcPkfdcNTQOEozUEH+/zGs+ZI=";
=======
    hash = "sha256-BbHsOiySt9q2S2GfYuTm9Q9gF7+X7cHIyiaBZ5Ze+14=";
  };
  npmDepsHash = "sha256-evhtWDx3gBw+A8GlVrOQ0+5i84ASTSoq0/zgl6QibSE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.tests.zwave-js-ui = nixosTests.zwave-js-ui;

  meta = {
    description = "Full featured Z-Wave Control Panel and MQTT Gateway";
    homepage = "https://zwave-js.github.io/zwave-js-ui/";
    license = lib.licenses.mit;
    downloadPage = "https://github.com/zwave-js/zwave-js-ui/releases";
    changelog = "https://github.com/zwave-js/zwave-js-ui/blob/v${version}/CHANGELOG.md";
    mainProgram = "zwave-js-ui";
    maintainers = with lib.maintainers; [ cdombroski ];
  };
}
