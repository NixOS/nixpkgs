{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,
  poetry-core,
  snowballstemmer,
  tomli,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "6.3.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pydocstyle";
    tag = version;
    hash = "sha256-MjRrnWu18f75OjsYIlOLJK437X3eXnlW8WkkX7vdS6k=";
  };

  patches = [
    # https://github.com/PyCQA/pydocstyle/pull/656
    (fetchpatch2 {
      name = "python312-compat.patch";
      url = "https://github.com/PyCQA/pydocstyle/commit/306c7c8f2d863bdc098a65d2dadbd4703b9b16d5.patch";
      hash = "sha256-bqnoLz1owzDpFqlZn8z4Z+RzKCYBsI0PqqeOtjLxnMo=";
    })
  ];

  nativeBuildInputs = [ poetry-core ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0-dev"' 'version = "${version}"'
  '';

  propagatedBuildInputs = [ snowballstemmer ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies.toml = [ tomli ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.toml;

  disabledTestPaths = [
    "src/tests/test_integration.py" # runs pip install
  ];

  meta = with lib; {
    description = "Python docstring style checker";
    mainProgram = "pydocstyle";
    homepage = "https://github.com/PyCQA/pydocstyle";
    changelog = "https://github.com/PyCQA/pydocstyle/blob/${version}/docs/release_notes.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
