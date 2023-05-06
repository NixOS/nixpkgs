{ lib
, buildPythonPackage
, fetchPypi
, psutil
}:

buildPythonPackage rec {
  pname = "python-pidfile";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HhCX30G8dfV0WZ/++J6LIO/xvfyRkdPtJkzC2ulUKdA=";
  };

  propagatedBuildInputs = [
    psutil
  ];

  pythonImportsCheck = [ "pidfile" ];

  # no tests on the github mirror of the source code
  # see this: https://github.com/mosquito/python-pidfile/issues/7
  doCheck = false;

  meta = with lib; {
    description = "Python context manager for managing pid files";
    homepage = "https://github.com/mosquito/python-pidfile";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lom ];
  };
}
