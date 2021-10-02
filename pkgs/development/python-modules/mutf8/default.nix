{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mutf8";
  version = "1.0.5";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = pname;
    rev = "v${version}";
    sha256 = "0blp6gb7q3f7if326xard8zlfg2rcmb3a7mxvaxgkvxigipjb9af";
  };

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    # Using pytestCheckHook results in test failures
    pytest
  '';

  pythonImportsCheck = [ "mutf8" ];

  meta = with lib; {
    description = "Fast MUTF-8 encoder & decoder";
    homepage = "https://github.com/TkTech/mutf8";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
