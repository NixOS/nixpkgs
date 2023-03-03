{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "cppy";
  version = "1.2.1";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-g7Q78XsQhawVxd69tCFU8Ti5KCNLIURzWJgfadDW/hs=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cppy" ];

  meta = {
    description = "C++ headers for C extension development";
    homepage = "https://github.com/nucleic/cppy";
    license = lib.licenses.bsd3;
  };
}
