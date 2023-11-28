{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, pythonOlder
, typing ? null
, funcsigs ? null
}:

buildPythonPackage rec {
  pname = "gentools";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ariebovenberg";
    repo = "gentools";
    rev = "refs/tags/v${version}";
    hash = "sha256-RBUIji3FOIRjfp4t7zBAVSeiWaYufz4ID8nTWmhDkf8=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs =
    lib.optionals (pythonOlder "3.5") [ typing ] ++
    lib.optionals (pythonOlder "3.4") [ funcsigs ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportCheck = [ "gentools" ];

  meta = with lib; {
    description = "Tools for generators, generator functions, and generator-based coroutines";
    homepage = "https://gentools.readthedocs.io/";
    changelog = "https://github.com/ariebovenberg/gentools/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ mredaelli ];
  };
}
