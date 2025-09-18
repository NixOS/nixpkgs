{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "elm-test";
  version = "0.19.1-revision16";

  src = fetchFromGitHub {
    owner = "rtfeldman";
    repo = "node-test-runner";
    rev = version;
    hash = "sha256-5XV5AxLJ3YdtlB3Px5tmFzP8H2BP8lkq9M01iUbbmPU=";
  };

  npmDepsHash = "sha256-+e21gMBiRQo1uUIvlIs5fzkyWW6+zWEi2HGdDsXxgaA=";

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
