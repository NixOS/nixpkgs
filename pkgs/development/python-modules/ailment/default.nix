{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-F0t4vVxi4KUUtIZc8FJD9+2qf1XA58haFfjmHwAQaWA=";
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
