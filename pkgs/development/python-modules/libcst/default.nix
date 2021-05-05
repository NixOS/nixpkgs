{ lib
, buildPythonPackage
, dataclasses
, fetchFromGitHub
, hypothesis
, pytestCheckHook
, pythonOlder
, pyyaml
, typing-extensions
, typing-inspect
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.3.18";
  disabled = pythonOlder "3.6";

  # Some files for tests missing from PyPi
  # https://github.com/Instagram/LibCST/issues/331
  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-19yGaKBLpGASSPv/aSX0kx9lh2JxKExHJDKKtuBbuqI=";
  };

  propagatedBuildInputs = [
    hypothesis
    typing-extensions
    typing-inspect
    pyyaml
  ] ++ lib.optional (pythonOlder "3.7") dataclasses;

  checkInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    # Can't run tests due to circular dependency on hypothesmith -> libcst
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
