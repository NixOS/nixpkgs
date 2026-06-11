{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  more-itertools,
  numpy,
}:

buildPythonPackage rec {
  pname = "parsnip";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "parsnip";
    tag = "v${version}";
    hash = "sha256-BCEQnClT/dI+t8RwMEQkzbFVCmDThiS9m8ZBCIEFrlg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    more-itertools
    numpy
  ];

  pythonImportsCheck = [
    "parsnip"
  ];

  meta = {
    description = "Lightweight, performant library for parsing CIF files in Python";
    homepage = "https://github.com/glotzerlab/parsnip";
    changelog = "https://github.com/glotzerlab/parsnip/blob/${src.tag}/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
