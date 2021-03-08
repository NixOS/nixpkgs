{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.65";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bldhg81lal9mbf55ky3gj2ndlplr0vfjp1bamd0mz5d9icas8nf";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "pywilight" ];

  meta = with lib; {
    description = "Python API for WiLight device";
    homepage = "https://github.com/leofig-rj/pywilight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
