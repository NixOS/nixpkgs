{ lib
, buildPythonPackage
, fetchPypi
, pytest
, isPy27
}:

buildPythonPackage rec {
  version = "1.1.1";
  pname = "pysnooper";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    sha256 = "sha256-0X3JHMoVk8ECMNzkXkax0/8PiRDww46UHt9roSYLOCA=";
  };

  # test dependency python-toolbox fails with py27
  doCheck = !isPy27;

  checkInputs = [
    pytest
  ];

  meta = with lib; {
    description = "A poor man's debugger for Python";
    homepage = "https://github.com/cool-RR/PySnooper";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
