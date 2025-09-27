{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  more-itertools,
  numpy,
}:

buildPythonPackage rec {
  pname = "parsnip";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glotzerlab";
    repo = "parsnip";
    rev = "v${version}";
    hash = "sha256-Nac0afep7+HkpSBpqClHpPFSc8H3g8l4q067RQe5K54=";
  };

  build-system = [
    setuptools
    wheel
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
    changelog = "https://github.com/glotzerlab/parsnip/blob/${src.rev}/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
