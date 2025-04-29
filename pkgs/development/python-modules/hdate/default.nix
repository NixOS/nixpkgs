{
  lib,
  astral,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  num2words,
  pdm-backend,
  pytest-timeout,
  pytest-xdist,
  pytestCheckHook,
  syrupy,
}:

buildPythonPackage rec {
  pname = "hdate";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "py-libhdate";
    repo = "py-libhdate";
    tag = "v${version}";
    hash = "sha256-J2ZbfzQdQSlnwcygwapDKkvZIx2VrlaaRe244V8Zt5c=";
  };

  pythonRelaxDeps = [
    "astral"
  ];

  build-system = [
    pdm-backend
  ];

  dependencies = [
    num2words
  ];

  optional-dependencies = {
    astral = [ astral ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-timeout
    pytest-xdist
    pytestCheckHook
    syrupy
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [ "hdate" ];

  meta = with lib; {
    description = "Python module for Jewish/Hebrew date and Zmanim";
    homepage = "https://github.com/py-libhdate/py-libhdate";
    changelog = "https://github.com/py-libhdate/py-libhdate/blob/${src.tag}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fab ];
  };
}
