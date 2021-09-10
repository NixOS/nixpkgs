{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mutf8";
  version = "1.0.4";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "TkTech";
    repo = pname;
    rev = "v${version}";
    sha256 = "1p9ml7g92sk28r3xa4pbib019i839z7xi253pn1hkkdgc3i4plzp";
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
