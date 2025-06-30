{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  packaging,
  pytest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "15.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-rerunfailures";
    tag = version;
    hash = "sha256-ab3n61zCf9ok2PWvKTwmaeoeGuMxl0sYE25djk/NDLk=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
