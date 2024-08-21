{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pysnooper";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "PySnooper";
    hash = "sha256-gQZp4WKiUKBm2GYuVzrbxa93DpN8W1V48ou3NV0chZs=";
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
