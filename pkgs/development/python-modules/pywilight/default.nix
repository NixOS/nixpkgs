{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.73";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f0063301e3cba828b3fc437a7094a11a7ac84a28c1a451c053fbb7e797f92236";
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
