{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, hypothesis
, dataclasses
, hypothesmith
, pytestCheckHook
, pyyaml
, typing-extensions
, typing-inspect
, black
, isort
}:

buildPythonPackage rec {
  pname = "libcst";
  version = "0.3.19";

  # Some files for tests missing from PyPi
  # https://github.com/Instagram/LibCST/issues/331
  src = fetchFromGitHub {
    owner = "instagram";
    repo = pname;
    rev = "v${version}";
    sha256 = "012g1hyaj015k2sf38a7jnpzjic0f8j97ar84d0f00w2ifzwx4ma";
  };

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [ hypothesis typing-extensions typing-inspect pyyaml ]
    ++ lib.optional (pythonOlder "3.7") dataclasses;

  checkInputs = [ black hypothesmith isort pytestCheckHook ];

  # can't run tests due to circular dependency on hypothesmith -> licst
  doCheck = false;

  preCheck = ''
    python -m libcst.codegen.generate visitors
    python -m libcst.codegen.generate return_types
  '';

  pythonImportsCheck = [ "libcst" ];

  meta = with lib; {
    description = "A Concrete Syntax Tree (CST) parser and serializer library for Python.";
    homepage = "https://github.com/Instagram/libcst";
    license = with licenses; [ mit asl20 psfl ];
    maintainers = with maintainers; [ ruuda SuperSandro2000 ];
  };
}
