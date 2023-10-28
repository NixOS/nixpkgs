{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
, fastapi
, python-socketio
, pytest
}:

buildPythonPackage rec {
  pname = "fastapi-socketio";
  version = "0.0.10";
  format = "pyproject";

  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IC+bMZ8BAAHL0RFOySoNnrX1ypMW6uX9QaYIjaCBJyc=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    fastapi
    python-socketio
  ];

  passthru.optional-dependencies = {
    test = [
      pytest
    ];
  };

  pythonImportsCheck = [ "fastapi_socketio" ];

  meta = with lib; {
    description = "Easily integrate socket.io with your FastAPI app";
    homepage = "https://pypi.org/project/fastapi-socketio/";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
