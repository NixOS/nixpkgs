{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysnooper";
  version = "1.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    hash = "sha256-2DLd8myARAqUVrOmZNr/lX9zfnMTxAt2JQ69tczbajE=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pysnooper" ];

  meta = with lib; {
    description = "Poor man's debugger for Python";
    homepage = "https://github.com/cool-RR/PySnooper";
    license = licenses.mit;
    maintainers = with maintainers; [ seqizz ];
  };
}
