{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fuzzyfinder";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c56d86f110866becad6690c7518f7036c20831c0f82fc87eba8fdb943132f04b";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fuzzyfinder" ];

  meta = with lib; {
    description = "Fuzzy Finder implemented in Python";
    homepage = "https://github.com/amjith/fuzzyfinder";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
