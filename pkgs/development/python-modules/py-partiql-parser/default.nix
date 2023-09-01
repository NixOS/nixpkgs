{ lib
, buildPythonPackage
, fetchFromGitHub
, nix-update-script
, pytestCheckHook
, setuptools
, sure
}:

buildPythonPackage rec {
  pname = "py-partiql-parser";
  version = "0.3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "getmoto";
    repo = "py-partiql-parser";
    rev = "refs/tags/${version}";
    hash = "sha256-RObJSvkqD3T8i470po/CayGC/ae8J6rFQROsrQ1EAGs=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sure
  ];

  pythonImportsCheck = [
    "py_partiql_parser"
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "A tokenizer/parser/executor for the PartiQL-language, in Python";
    homepage = "https://github.com/getmoto/py-partiql-parser";
    changelog = "https://github.com/getmoto/py-partiql-parser/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ centromere ];
  };
}
