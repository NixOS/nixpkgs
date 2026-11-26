{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "dacite";
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "konradhalas";
    repo = "dacite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0hemRPKQvCmRts68zsfKZSL/yKK2g+F/6B97iDryles=";
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
    changelog = "https://github.com/konradhalas/dacite/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
