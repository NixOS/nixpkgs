{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.44.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-3dYczeq3ZGzA4E07lJfuR7039U+LaxVbWGlfMF9+iiY=";
  };

  npmDepsHash = "sha256-jec/XyYDGhvl3fngG/HGJMI1G5JtYuZi/pJFrZuir+A=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
