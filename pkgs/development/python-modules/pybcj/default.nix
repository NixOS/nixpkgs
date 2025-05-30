{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  setuptools,
  setuptools-scm,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pybcj";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "miurahr";
    repo = "pybcj";
    tag = "v${version}";
    hash = "sha256-ExSt7E7ZaVEa0NwAQHU0fOaXJW9jYmEUUy/1iUilGz8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "bcj"
  ];

  meta = {
    description = "BCJ (Branch-Call-Jump) filter for Python";
    homepage = "https://codeberg.org/miurahr/pybcj";
    changelog = "https://codeberg.org/miurahr/pybcj/src/tag/v${version}/Changelog.rst#v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      pitkling
      PopeRigby
    ];
  };
}
