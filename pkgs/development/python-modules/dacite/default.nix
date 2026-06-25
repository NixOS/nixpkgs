{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dacite";
  version = "1.9.2-fix";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = "dacite";
    tag = "v${version}";
    hash = "sha256-n5fD0s3Zp77U8fYW5p6tmB9VS65eimnG9gMM/71LU3c=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--benchmark-autosave --benchmark-json=benchmark.json" ""
  ''
  + lib.optionalString (pythonAtLeast "3.14") ''
    substituteInPlace tests/core/test_union.py \
      --replace-fail "typing.Union[int, str]" "int | str"
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dacite" ];

  disabledTestPaths = [ "tests/performance" ];

  meta = {
    description = "Python helper to create data classes from dictionaries";
    homepage = "https://github.com/konradhalas/dacite";
    changelog = "https://github.com/konradhalas/dacite/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
