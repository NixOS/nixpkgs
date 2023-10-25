{ lib
, beautifulsoup4
, buildPythonPackage
, bunch
, fetchPypi
, kitchen
, lockfile
, munch
, openidc-client
, paver
, pythonOlder
, requests
, six
, urllib3
}:

buildPythonPackage rec {
  pname = "python-fedora";
  version = "1.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VrnYQaObQDDjiOkMe3fazUefHOXi/5sYw5VNl9Vwmhk=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    bunch
    kitchen
    lockfile
    munch
    openidc-client
    paver
    requests
    six
    urllib3
  ];

  doCheck = false;

  pythonImportsCheck = [
    "fedora"
  ];

  meta = with lib; {
    description = "Module to interact with the infrastructure of the Fedora Project";
    homepage = "https://github.com/fedora-infra/python-fedora";
    changelog = "https://github.com/fedora-infra/python-fedora/releases/tag/1.1.1";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
