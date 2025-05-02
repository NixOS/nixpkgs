{
  buildPythonPackage,
  fetchPypi,
  lib,
  plumbum,
  ply,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pandoc";
  version = "2.4";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pandoc";
    hash = "sha256-7NH4y7f0GAxrXbShenwadN9RmZX18Ybvgc5yqcvQ3Zo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    plumbum
    ply
  ];

  pythonImportsCheck = [ "pandoc" ];

  meta = {
    description = "Library Pandoc's data model for markdown documents";
    homepage = "https://boisgera.github.io/pandoc/";
    changelog = "https://github.com/boisgera/pandoc/blob/v${version}/mkdocs/changelog.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jupblb
      tylerjl
    ];
  };
}
