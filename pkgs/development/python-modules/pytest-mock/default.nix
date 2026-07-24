{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pytest-mock";
  version = "3.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-mock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9h5/cssWs4F0LKnFLjWDsEjB2AYczLvnSjiUdsaEcBQ=";
  };

  patches = [
    (fetchpatch {
      name = "pytest-9.1-compat.patch";
      url = "https://github.com/pytest-dev/pytest-mock/commit/1d42981a1577207db5919852f30ef08c97208496.patch";
      hash = "sha256-9/vQi/VvZRrIUSq1e90MvLB0idkc+tT4R6q1Ut4HKnY=";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_mock" ];

  __structuredAttrs = true;

  meta = {
    description = "Thin wrapper around the mock package for easier use with pytest";
    homepage = "https://github.com/pytest-dev/pytest-mock";
    changelog = "https://github.com/pytest-dev/pytest-mock/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
