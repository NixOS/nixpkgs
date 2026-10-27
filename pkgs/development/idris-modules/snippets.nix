{
  build-idris-package,
  fetchFromGitHub,
  contrib,
  lib,
}:
build-idris-package {
  pname = "snippets";
  version = "2018-03-17";

  ipkgName = "idris-snippets";
  idrisDeps = [ contrib ];

  src = fetchFromGitHub {
    owner = "palladin";
    repo = "idris-snippets";
    rev = "c26d6f5ffc1cc0456279f5ac74fec5af8c09025e";
    hash = "sha256-VsJKutDmGPpAqssrAbLQOXVDU5QCSK9d5MMqbyb7nu8=";
  };

  meta = {
    description = "Collection of Idris snippets";
    homepage = "https://github.com/palladin/idris-snippets";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
