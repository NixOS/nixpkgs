{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
  # Check inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fastjsonschema";
  version = "2.14.4";

  disabled = pythonOlder "3.3";

  src = fetchFromGitHub {
    owner = "horejsek";
    repo = "python-fastjsonschema";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "0c3q31lqzrc52gacnqc271k5952qbyl0z4kagsqvl7fiwk84hqlz";
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
