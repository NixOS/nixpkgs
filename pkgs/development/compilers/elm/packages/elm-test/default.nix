{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "elm-test";
  version = "0.19.2-0";

  src = fetchFromGitHub {
    owner = "rtfeldman";
    repo = "node-test-runner";
    rev = version;
    hash = "sha256-Kta6O4EYeqqEmkRXs0yLzTL47RY8DiyAwszhjWi3xwU=";
  };

  npmDepsHash = "sha256-J1o5dsjyiDav5KELjFGibYETmJO6j8CmLzP7pg/tncM=";

  postPatch = ''
    sed -i '/elm-tooling install/d' package.json
  '';

  dontNpmBuild = true;

  postInstall = ''
    # clean up broken symlinks to build tool binaries
    find $out/lib/node_modules/elm-test/node_modules/.bin \
      -xtype l \
      -delete
  '';

  meta = {
    changelog = "https://github.com/rtfeldman/node-test-runner/blob/${src.rev}/CHANGELOG.md";
    description = "Runs elm-test suites from Node.js";
    mainProgram = "elm-test";
    homepage = "https://github.com/rtfeldman/node-test-runner";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ turbomack ];
  };
}
