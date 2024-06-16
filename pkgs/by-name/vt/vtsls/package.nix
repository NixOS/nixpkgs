{ lib
, buildNpmPackage
, fetchFromGitHub
, importNpmLock
}:

buildNpmPackage rec {
  pname = "vtsls";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "yioneko";
    repo = "vtsls";
    rev = "server-v${version}";
    hash = "sha256-rHiH42WpKR1nZjsW+Q4pit1aLbNIKxpYSy7sjPS0WGc=";
    fetchSubmodules = true;
  };

  sourceRoot = "${src.name}/packages/server";

  npmDeps = importNpmLock {
    npmRoot = "${src}/packages/server";
    packageLock = lib.importJSON ./package-lock.json;
  };

  npmDepsHash = "sha256-R70+8vwcZHlT9J5MMCw3rjUQmki4/IoRYHO45CC8TiI=";

  npmConfigHook = importNpmLock.npmConfigHook;

  dontNpmPrune = true;

  meta = with lib; {
    description = "LSP wrapper around TypeScript extension bundled with VSCode.";
    homepage = "https://github.com/yioneko/vtsls";
    license = licenses.mit;
    maintainers = with maintainers; [ wizardlink ];
    platforms = platforms.all;
  };
}
