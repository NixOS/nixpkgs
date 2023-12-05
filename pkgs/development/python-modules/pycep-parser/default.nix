{ lib
, assertpy
, buildPythonPackage
, fetchFromGitHub
, lark
, poetry-core
, pytestCheckHook
, pythonOlder
, regex
, typing-extensions
}:

buildPythonPackage rec {
  pname = "pycep-parser";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gruebel";
    repo = "pycep";
    rev = "refs/tags/${version}";
    hash = "sha256-qogUjj/GwMGwFEin+xJCSOCf5Ut8bgsFakyoMhkyKgU=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    lark
    regex
    typing-extensions
  ];

  nativeCheckInputs = [
    assertpy
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pycep"
  ];

  meta = with lib; {
    description = "Python based Bicep parser";
    homepage = "https://github.com/gruebel/pycep";
    changelog = "https://github.com/gruebel/pycep/blob/${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
