{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, networkx
, pytestCheckHook
}:

buildPythonPackage {
  pname = "importlab";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "google";
    repo = "importlab";
    rev = "676d17cd41ac68de6ebb48fb71780ad6110c4ae3";
    sha256 = "sha256-O8y1c65NQ+19BnGnUnWrA0jYUqF+726CFAcWzHFOiHE=";
  };

  propagatedBuildInputs = [ networkx ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [ "tests/test_parsepy.py" ];

  pythonImportsCheck = [ "importlab" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A library that automatically infers dependencies for Python files";
    homepage = "https://github.com/google/importlab";
    license = licenses.mit;
    maintainers = with maintainers; [ sei40kr ];
  };
}
