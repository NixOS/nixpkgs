{ buildPythonPackage
, fetchPypi
, isPy27
, lib
, numpy
}:

buildPythonPackage rec {
  pname = "javaobj-py3";
  version = "0.4.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7Tsf/P058WVynLU1h8ygKrC/pMMyyDepLV/+au9cgBA=";
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
