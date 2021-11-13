{ lib
, buildPythonPackage
, c-ares
, cffi
, fetchPypi
, idna
}:

buildPythonPackage rec {
  pname = "pycares";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-A0kL4Oe1GgyAc/h3vsNH7/MQA/ZPV9lRjUGdk2lFKDc=";
  };

  buildInputs = [
    c-ares
  ];

  propagatedBuildInputs = [
    cffi
    idna
  ];

  # Requires network access
  doCheck = false;

  pythonImportsCheck = [ "pycares" ];

  meta = with lib; {
    description = "Python interface for c-ares";
    homepage = "https://github.com/saghul/pycares";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
