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
  version = "16.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pytest-dev";
    repo = "pytest-rerunfailures";
    tag = version;
    hash = "sha256-4/BgvfVcs7MdULlhafZypNzzag4ITALStHI1tIoAPL4=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [ packaging ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    changelog = "https://github.com/pytest-dev/pytest-rerunfailures/blob/${src.tag}/CHANGES.rst";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
