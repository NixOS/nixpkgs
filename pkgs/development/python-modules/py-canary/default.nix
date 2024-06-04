{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  pythonOlder,
  requests,
  requests-mock,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-canary";
  version = "0.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "snjoetw";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-873XAf0jOX5pjrNRELEcTWCauk80FUYxTu7G7jc3MHE=";
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

  meta = with lib; {
    description = "Python package for Canary Security Camera";
    homepage = "https://github.com/snjoetw/py-canary";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
