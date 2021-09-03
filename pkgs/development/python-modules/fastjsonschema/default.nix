{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.15.1";

  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-ltxFJ3V5/bckusspQ5o0F4reMoB4KpYWPHF8ZNXGqVQ=";
  };

  checkInputs = [ pytestCheckHook ];
  dontUseSetuptoolsCheck = true;
  disabledTests = [
    "benchmark"
    # these tests require network access
    "remote ref"
    "definitions"
  ];

  pythonImportsCheck = [ "fastjsonschema" ];

  meta = with lib; {
    description = "Fast JSON schema validator for Python.";
    homepage = "https://horejsek.github.io/python-fastjsonschema/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
