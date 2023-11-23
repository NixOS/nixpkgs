{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, networkx
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "importlab";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-s4k4U7H26wJ9pQnDtA5nh+ld1mtLZvGzYTqtd1VuFGU=";
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
