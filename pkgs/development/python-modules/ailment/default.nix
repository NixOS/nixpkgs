{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.0.8021";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DeQvYuVRYOxyVPqHzTSNtEUUN4tHhSVMZoex6SUWik8=";
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
