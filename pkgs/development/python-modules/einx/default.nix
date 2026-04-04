{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  numpy,
  sympy,
  frozendict,
}:

buildPythonPackage rec {
  pname = "einx";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fferflo";
    repo = "einx";
    rev = "v${version}";
    hash = "sha256-dOwAcTs7e1BuqUFfqJGKsJhD8mxHTuctkgMH8H0gakA=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    numpy
    sympy
    frozendict
  ];

  pythonImportsCheck = [
    "einx"
  ];

  meta = {
    description = "Universal Tensor Operations in Einstein-Inspired Notation for Python";
    homepage = "https://github.com/fferflo/einx";
    changelog = "https://github.com/fferflo/einx/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
