{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
, setuptools
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.25";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AXMqCNnN63sCi5IlichNQhgXKxONnue//8ECi77Gf8Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
