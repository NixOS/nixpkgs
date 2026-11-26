{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.22.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-KbgY8wJW5BHo1EUZzY+dUlNN4Bk/8DFHxQHkVNHoHKA=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "benchmark"
    # these tests require network access
    "remote"
    "ref"
    "definitions"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_compile_to_code_custom_format" # cannot import temporary module created during test
  ];

  disabledTestPaths = [
    # fastjsonschema.exceptions.JsonSchemaDefinitionException: Unknown format uuid/duration
    "tests/json_schema/test_draft2019.py::test"
  ];

  pythonImportsCheck = [ "fastjsonschema" ];

  meta = {
    description = "JSON schema validator for Python";
    downloadPage = "https://github.com/horejsek/python-fastjsonschema";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
