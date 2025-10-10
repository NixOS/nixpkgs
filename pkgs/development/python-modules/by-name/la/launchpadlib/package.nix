{
  lib,
  buildPythonPackage,
  fetchPypi,
  httplib2,
  lazr-restfulclient,
  lazr-uri,
  setuptools,
  six,
  testresources,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "launchpadlib";
  version = "2.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tMJYkLt1BQ1UwIEj0nMxVreKWaJVX1Rh9psORM2RJC8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httplib2
    lazr-restfulclient
    lazr-uri
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
    testresources
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [
    "launchpadlib"
    "launchpadlib.apps"
    "launchpadlib.credentials"
  ];

  meta = with lib; {
    description = "Script Launchpad through its web services interfaces. Officially supported";
    homepage = "https://help.launchpad.net/API/launchpadlib";
    license = licenses.lgpl3Only;
    maintainers = [ ];
  };
}
