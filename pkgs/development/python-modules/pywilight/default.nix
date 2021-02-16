{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.68";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1s1xyw5hkfr4rlni1p9z4941pp1740fsg4a3b23a618hv2p1i4ww";
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
