{ lib
, buildPythonPackage
, fetchPypi
, flit-core
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "idna";
  version = "3.4";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gU9Sjo3q19MpgzuRxfqofWC/cYJM0Sp1MLVSYGPQLLQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/kjd/idna/";
    description = "Internationalized Domain Names in Applications (IDNA)";
    license = lib.licenses.bsd3;
  };
}
