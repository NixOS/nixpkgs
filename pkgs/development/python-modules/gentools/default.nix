{ lib
, buildPythonPackage
, fetchFromGitHub
, importlib-metadata
, poetry-core
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gentools";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "gentools";
    rev = "refs/tags/v${version}";
    hash = "sha256-RBUIji3FOIRjfp4t7zBAVSeiWaYufz4ID8nTWmhDkf8=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gentools"
  ];

  meta = with lib; {
    description = "Tools for generators, generator functions, and generator-based coroutines";
    homepage = "https://gentools.readthedocs.io/";
    changelog = "https://github.com/ariebovenberg/gentools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
