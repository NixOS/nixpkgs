{ lib
, buildPythonPackage
, fetchPypi
, yajl
, cffi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ijson";
  version = "3.2.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EClOm/ictxPaBbxHkL3/YWYQQy21YZZIJwdImOF0+Rc=";
  };

  buildInputs = [
    yajl
  ];

  propagatedBuildInputs = [
    cffi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = true;

  pythonImportsCheck = [
    "ijson"
  ];

  meta = with lib; {
    description = "Iterative JSON parser with a standard Python iterator interface";
    homepage = "https://github.com/ICRAR/ijson";
    changelog = "https://github.com/ICRAR/ijson/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
  };
}
