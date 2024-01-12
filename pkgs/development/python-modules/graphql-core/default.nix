{ lib
, buildPythonPackage
, fetchFromGitHub
, py
, pytest-benchmark
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, poetry-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "graphql-core";
  version = "3.3.0a3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "graphql-python";
    repo = "graphql-core";
    rev = "refs/tags/v${version}";
    hash = "sha256-RX1oKiQ0q934yQJuTzP2+87bMTKUZeoFjooshFcXPJ8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    py
    pytest-asyncio
    pytest-benchmark
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "graphql"
  ];

  meta = with lib; {
    description = "Port of graphql-js to Python";
    homepage = "https://github.com/graphql-python/graphql-core";
    changelog = "https://github.com/graphql-python/graphql-core/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
}
