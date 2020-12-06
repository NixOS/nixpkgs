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
  version = "1.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "22524120d744b50d25ef6bfc7052637e4ead9e2afac92563231ec89848f5adf5";
  };

  propagatedBuildInputs = [ lxml requests ];

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
