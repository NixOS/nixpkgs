{ lib
, buildPythonPackage
, fetchPypi
, cryptography
}:

buildPythonPackage rec {
  pname = "broadlink";
  version = "0.17.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfd1ff007d0d1187c17ae52be938afc8137fbd1ed6a794426e975df10d167571";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    "broadlink"
  ];

  meta = with lib; {
    description = "Python API for controlling Broadlink IR controllers";
    homepage =  "https://github.com/mjg59/python-broadlink";
    license = licenses.mit;
  };
}
