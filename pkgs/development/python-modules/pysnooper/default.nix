{ lib
, buildPythonPackage
, fetchPypi
, pytest
, isPy27
}:

buildPythonPackage rec {
  version = "0.4.1";
  pname = "pysnooper";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    sha256 = "1xngly13x3ylwwcdml2ns8skpxip2myzavp3b9ff2dpqaalf0hdl";
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
