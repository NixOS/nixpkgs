{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.0.8761";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UAtVWh3BBZZmU5+BR0+2B+rivzR4E7bZK1ro1uKngtE=";
  };

  propagatedBuildInputs = [ pyvex ];

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
