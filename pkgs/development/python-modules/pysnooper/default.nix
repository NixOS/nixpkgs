{ lib
, buildPythonPackage
, fetchPypi
, python-toolbox
, pytest
, isPy27
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "pysnooper";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    sha256 = "14vcxrzfmfhsmdck1cb56a6lbfga15qfhlkap9mh47fgspcq8xkx";
  };

  # test dependency python-toolbox fails with py27
  doCheck = !isPy27;

  checkInputs = [
    python-toolbox
    pytest
  ];

  meta = with lib; {
    description = "A poor man's debugger for Python";
    homepage = https://github.com/cool-RR/PySnooper;
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
