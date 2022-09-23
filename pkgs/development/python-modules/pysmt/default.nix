{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmt";
  version = "0.9.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pysmt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cE+WmKzggYof/olxQb5M7xPsBONr39KdjOTG4ofYPUM=";
  };

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysmt"
  ];

  meta = with lib; {
    description = "Python library for SMT formulae manipulation and solving";
    homepage = "https://github.com/pysmt/pysmt";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
