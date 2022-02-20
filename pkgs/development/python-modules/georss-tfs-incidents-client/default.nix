{ lib
, buildPythonPackage
, fetchFromGitHub
, georss-client
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "georss-tfs-incidents-client";
  version = "0.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "exxamalte";
    repo = "python-georss-tfs-incidents-client";
    rev = "v${version}";
    hash = "sha256-9fDFm9GLXxy814wR75TjP3pfQPU+nCSV8Z509WXm24Y=";
  };

  propagatedBuildInputs = [
    georss-client
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "georss_tfs_incidents_client"
  ];

  meta = with lib; {
    description = "Python library for accessing Tasmania Fire Service Incidents feed";
    homepage = "https://github.com/exxamalte/python-georss-tfs-incidents-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
