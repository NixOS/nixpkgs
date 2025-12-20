{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.44.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-Z4ZdCSGqyu7jjpLgHEZCvrZj+IsqEbdcjATdy80TnC8=";
  };

  npmDepsHash = "sha256-Zmbh/NMriZtkYpFd5hCJo+nPrKTrqYfh3W+sZpopBHM=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
