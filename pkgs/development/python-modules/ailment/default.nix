{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.11";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hluPbUxkYlbeOsc5uQMXtFjt3wDHq/olUk2SKHPAlVU=";
  };

  propagatedBuildInputs = [
    pyvex
  ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  #pythonImportsCheck = [ "ailment" ];

  meta = with lib; {
    description = "The angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
