{ lib
, black
, buildPythonPackage
, dataclasses
, fetchFromGitHub
, hypothesis
, isort
, pytest
, python
, pythonOlder
, pyyaml
, typing-extensions
, typing-inspect
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.3.23";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "1r4aiqpndqa75119faknsghi7zxyjrx5r6i7cb3d0liwiqrkzrvx";
  };

  propagatedBuildInputs = [
    hypothesis
    typing-extensions
    typing-inspect
    pyyaml
  ] ++ lib.optional (pythonOlder "3.7") [
    dataclasses
  ];

  checkInputs = [
    black
    isort
    pytest
  ];

  preCheck = ''
    ${python.interpreter} -m libcst.codegen.generate visitors
    ${python.interpreter} -m libcst.codegen.generate return_types
    # Can't run all tests due to circular dependency on hypothesmith -> libcst
    rm -r {libcst/tests,libcst/codegen/tests,libcst/m*/tests}
  '';

  disabledTests = [
    # No files are generated
    "test_codemod_formatter_error_input"
  ];

  pythonImportsCheck = [
    "libcst"
  ];

  meta = with lib; {
    description = "Concrete Syntax Tree (CST) parser and serializer library for Python";
    homepage = "https://github.com/Instagram/libcst";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
