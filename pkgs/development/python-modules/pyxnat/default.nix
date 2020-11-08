{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, nose
, lxml
, requests
}:

buildPythonPackage rec {
  pname = "pyxnat";
  version = "1.3";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "113d13cs5ab7wy4vmyqyh8isjhlgfvan7y2g8n25vcpn3j4j00h0";
  };

  requiredPythonModules = [ lxml requests ];

  checkInputs = [ nose ];
  checkPhase = "nosetests pyxnat/tests";
  doCheck = false;  # requires a docker container running an XNAT server

  pythonImportsCheck = [ "pyxnat" ];

  meta = with lib; {
    homepage = "https://pyxnat.github.io/pyxnat";
    description = "Python API to XNAT";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
