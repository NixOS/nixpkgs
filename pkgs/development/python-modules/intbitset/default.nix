{ lib
, fetchPypi
, buildPythonPackage
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "intbitset";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-boPFun/aJSCqhWVCi7r4Qt63KT1mXzzYKByzklTS/3E=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "intbitset"
  ];

  meta = with lib; {
    description = "C-based extension implementing fast integer bit sets";
    homepage = "https://github.com/inveniosoftware/intbitset";
    changelog = "https://github.com/inveniosoftware-contrib/intbitset/blob/v${version}/CHANGELOG.rst";
    license = licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
