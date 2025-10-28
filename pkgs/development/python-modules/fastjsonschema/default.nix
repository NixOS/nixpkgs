{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.21.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-H/jmvm5U4RB9KuD5EgCedbc499Fl8L2S9Y5SXy51JP0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    "benchmark"
    # these tests require network access
    "remote ref"
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

  meta = with lib; {
    description = "JSON schema validator for Python";
    downloadPage = "https://github.com/horejsek/python-fastjsonschema";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
