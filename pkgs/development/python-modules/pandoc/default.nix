{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  plumbum,
  ply,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pandoc";
  version = "2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "boisgera";
    repo = "pandoc";
    tag = "v${version}";
    hash = "sha256-J3xwBU7IPMGvrYQLlPisg9L4Tkx2G2ogL6GmsPZpUhE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    plumbum
    ply
  ];

  pythonImportsCheck = [ "pandoc" ];

  # Tests requires network access and pdflatex
  doCheck = false;

  meta = {
    description = "Module for Pandoc";
    homepage = "https://github.com/boisgera/pandoc";
    changelog = "https://github.com/boisgera/pandoc/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
