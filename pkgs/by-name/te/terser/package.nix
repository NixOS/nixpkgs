{ buildNpmPackage, fetchFromGitHub, lib }:

buildNpmPackage rec {
  pname = "terser";
  version = "5.36.0";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-iPxcr7B2raTBFidPTwiETGusSy79tRYNzoJObyVYSWY=";
  };

  npmDepsHash = "sha256-o5bCrvjVLmnxvYJJTp1qENR0l0C32D+2LfMKitt6zuY=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
