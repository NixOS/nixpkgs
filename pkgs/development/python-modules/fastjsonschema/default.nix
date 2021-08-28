{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.14.5";

  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1hgzafswdw5zqrd8qhdxa43crzfy7lrlifdn90133a0h3psr7qs1";
  };

  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    "benchmark"

    # these tests require network access
    "remote ref"
    "definitions"
  ];

  meta = with lib; {
    description = "Fast JSON schema validator for Python.";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
