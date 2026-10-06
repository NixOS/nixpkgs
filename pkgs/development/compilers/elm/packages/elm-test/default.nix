{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "elm-test";
  version = "0.19.2-1";

  src = fetchFromGitHub {
    owner = "rtfeldman";
    repo = "node-test-runner";
    rev = version;
    hash = "sha256-xgz+YkVpHHsTx0BYs3BmSI/X+glnRmFSoT+TURn+F/4=";
  };

  npmDepsHash = "sha256-BHAJz/7k5ZZ0n2gi69DLau2JvFNhS2iKIRXe32mT+Z8=";

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
