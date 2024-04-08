{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.18.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-t6JnqQgsWAL8oL8+LO0xrXMYsZOlTF3DlXkRiqUzYtU=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::pytest.PytestRemovedIn8Warning"
  ];

  dontUseSetuptoolsCheck = true;

  disabledTests = [
    "benchmark"
    # these tests require network access
    "remote ref"
    "definitions"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_compile_to_code_custom_format"  # cannot import temporary module created during test
  ];

  pythonImportsCheck = [
    "fastjsonschema"
  ];

  meta = with lib; {
    description = "JSON schema validator for Python";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
