{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "terser";
  version = "5.47.1";

  src = fetchFromGitHub {
    owner = "terser";
    repo = "terser";
    rev = "v${version}";
    hash = "sha256-IgbYZ8Ox1SR+USrtFMqkt8C1bEqzHLJLrdAgYc/JBSg=";
  };

  npmDepsHash = "sha256-Bg91btVnpZKTKu9lrPlPtFcnHmpM0PU+QVxCPdkCeFI=";

  meta = {
    description = "JavaScript parser, mangler and compressor toolkit for ES6+";
    mainProgram = "terser";
    homepage = "https://terser.org";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ talyz ];
  };
}
