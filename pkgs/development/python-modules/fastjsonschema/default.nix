{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.16.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-Gojayel/xQ5gRI0nbwsroeSMdRndjb+8EniX1Qs4nbg=";
  };

  checkInputs = [
    pytestCheckHook
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
