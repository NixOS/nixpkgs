{ lib
, fetchPypi
, buildPythonPackage
, parameterized
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mistletoe";
  version = "1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fQwas3RwR9Fp+fxLkl0cuj9cE+rwuQw2W3LkflnQCgI=";
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
