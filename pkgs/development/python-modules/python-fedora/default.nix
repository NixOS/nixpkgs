{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchPypi,
  kitchen,
  lockfile,
  munch,
  nose,
  openidc-client,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  six,
  urllib3,
}:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "1.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VrnYQaObQDDjiOkMe3fazUefHOXi/5sYw5VNl9Vwmhk=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    beautifulsoup4
    kitchen
    lockfile
    munch
    openidc-client
    requests
    six
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    nose
  ];

  disabledTestPaths = [
    # requires network access
    "tests/functional/test_openidbaseclient.py"
  ];

  pythonImportsCheck = [ "fedora" ];

  meta = with lib; {
    description = "Module to interact with the infrastructure of the Fedora Project";
    homepage = "https://github.com/fedora-infra/python-fedora";
    changelog = "https://github.com/fedora-infra/python-fedora/releases/tag/${version}";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
