{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.49.2";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-leC95D+bBI9CvPlenOr/2+3LkL9HgK3iCu3FNxBUaOk=";
  };

  npmDepsHash = "sha256-wkvMDyWiPtQXaLDkPUCcVTQJXZ30QqPHdQXzMXrtHkY=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
