{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sfia+weaGxpULp7ywI3UUKB6K9k1wDyrIsMorXyk2Og=";
  };

  pythonImportsCheck = [
    "mistletoe"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Fast and extensible Markdown parser";
    homepage = "https://github.com/miyuchina/mistletoe";
    changelog = "https://github.com/miyuchina/mistletoe/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ eadwu ];
  };
}
