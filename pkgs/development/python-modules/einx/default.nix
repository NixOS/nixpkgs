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

buildPythonPackage (finalAttrs: {
  pname = "einx";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fferflo";
    repo = "einx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xYnlIN+O2s0tTBpqiGiiA6p6QpF5olPFbYaiLPT8B1s=";
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
    changelog = "https://github.com/fferflo/einx/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
