{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "elm-test";
  version = "0.19.3-0";

  src = fetchFromGitHub {
    owner = "rtfeldman";
    repo = "node-test-runner";
    rev = version;
    hash = "sha256-l/IXzsDL4O2ldwdTZ4G5+kgBdkBmKbjOkZZYChdLOVA=";
  };

  npmDepsHash = "sha256-V5ZI27VF1FkY9oP0F3udyg7zXNfS7V1gR6KyWTMnCag=";

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
