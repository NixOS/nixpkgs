{ lib
, buildPythonPackage
, fetchPypi
, pytest
, isPy27
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "pysnooper";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    sha256 = "4804aed962f36db85fefdc33edbd109b96a13153e6ffed82d1e6023b4f483b64";
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
