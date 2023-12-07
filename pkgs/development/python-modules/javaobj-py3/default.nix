{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, numpy
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.4.3";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "38f74db3a57e9998a9774e3614afb95cb396f139f29b3fdb130c5af554435259";
  };

  propagatedBuildInputs = [ numpy ];

  # Tests assume network connectivity
  doCheck = false;

  pythonImportsCheck = [ "javaobj" ];

  meta = with lib; {
    description = "Module for serializing and de-serializing Java objects";
    homepage = "https://github.com/tcalmant/python-javaobj";
    license = licenses.asl20;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
