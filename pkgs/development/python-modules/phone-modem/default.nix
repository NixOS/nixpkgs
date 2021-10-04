{ lib
, aioserial
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "phone-modem";
  version = "0.1.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "phone_modem";
    inherit version;
    sha256 = "0kqa1ky5hjs9zdp3dnd8s9mz5p6z0al3hxxlgqdq9vnnpnv0lafy";
  };

  propagatedBuildInputs = [
    aioserial
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "phone_modem" ];

  meta = with lib; {
    description = "Python module for receiving caller ID and call rejection";
    homepage = "https://github.com/tkdrob/phone_modem";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
