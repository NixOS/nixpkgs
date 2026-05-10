{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-canary";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snjoetw";
    repo = "py-canary";
    tag = version;
    hash = "sha256-zylWkssU85eSfR+Di7vQGTr6hOQkqXCObv/PCDHoKHA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "canary" ];

  disabledTests = [
    # Test requires network access
    "test_location_with_motion_entry"
  ];

  meta = {
    description = "Python package for Canary Security Camera";
    homepage = "https://github.com/snjoetw/py-canary";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
