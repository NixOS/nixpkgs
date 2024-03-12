{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pythonAtLeast
, poetry-core
, snowballstemmer
, tomli
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "6.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pydocstyle";
    rev = "refs/tags/${version}";
    hash = "sha256-MjRrnWu18f75OjsYIlOLJK437X3eXnlW8WkkX7vdS6k=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0-dev"' 'version = "${version}"'
  '';

  propagatedBuildInputs = [
    snowballstemmer
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  passthru.optional-dependencies.toml = [
    tomli
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.toml;

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    "test_simple_fstring"
    "test_fstring_with_args"
  ];

  disabledTestPaths = [
    "src/tests/test_integration.py" # runs pip install
  ];

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = "https://github.com/PyCQA/pydocstyle";
    changelog = "https://github.com/PyCQA/pydocstyle/blob/${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
