{ lib
, buildPythonPackage
, fetchFromGitHub
  #, pytestCheckHook
, pythonOlder
, pkg-config
, gammu
}:

buildPythonPackage rec {
  pname = "python-gammu";
  version = "3.1";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = pname;
    rev = version;
    sha256 = "1hw2mfrps6wqfyi40p5mp9r59n1ick6pj4hw5njz0k822pbb33p0";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gammu ];

  # Check with the next release if tests could be run with pytest
  # checkInputs = [ pytestCheckHook ];
  # Don't run tests for now
  doCheck = false;
  pythonImportsCheck = [ "gammu" ];

  meta = with lib; {
    description = "Python bindings for Gammu";
    homepage = "https://github.com/gammu/python-gammu/";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
