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
  version = "0.3.20";
  disabled = pythonOlder "3.6";

  # Some files for tests missing from PyPi
  # https://github.com/Instagram/LibCST/issues/331
  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "063bl21gyyd25i2v0j6kz29cxxdfhng2nins4i2qblmac90f2nqy";
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

  pythonImportsCheck = [ "libcst" ];

  meta = with lib; {
    description = "Concrete Syntax Tree (CST) parser and serializer library for Python";
    homepage = "https://github.com/Instagram/libcst";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
