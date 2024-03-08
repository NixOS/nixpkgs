{ lib
, fetchPypi
, buildPythonPackage
, parameterized
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vQ54it2bRHjRnseS9tX7kIog5wq/5hGT8pF4xV062+k=";
  };

  pythonImportsCheck = [
    "mistletoe"
  ];

  nativeCheckInputs = [
    parameterized
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
