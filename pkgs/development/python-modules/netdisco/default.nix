{ lib, buildPythonPackage, isPy3k, fetchPypi, requests, zeroconf, pytestCheckHook }:

buildPythonPackage rec {
  pname = "netdisco";
  version = "2.9.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OpLFM+0ZmhggJ1SuLoSO+qWLcKcpS65sd7u2zkzPys4=";
  };

  propagatedBuildInputs = [ requests zeroconf ];

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [
    "netdisco"
    "netdisco.discovery"
  ];

  meta = with lib; {
    description = "Python library to scan local network for services and devices";
    homepage = "https://github.com/home-assistant/netdisco";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
