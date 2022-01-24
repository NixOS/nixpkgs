{ lib
, buildPythonPackage
, fetchPypi
, pytest
, isPy27
}:

buildPythonPackage rec {
  version = "1.1.0";
  pname = "pysnooper";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    sha256 = "0fa932ad396d2bac089d4b1f94f0ce49cde4140ee64ddd24a4065fadea10fcc9";
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
