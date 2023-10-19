{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pyvex
, setuptools
}:

buildPythonPackage rec {
  pname = "ailment";
  version = "9.2.73";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "angr";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-wMHyp6l7a5MuVX/q1QVfwZbuqBT6NbFltZsGopCjj3I=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    pyvex
  ];

  # Tests depend on angr (possibly a circular dependency)
  doCheck = false;

  pythonImportsCheck = [
    "ailment"
  ];

  meta = with lib; {
    description = "The angr Intermediate Language";
    homepage = "https://github.com/angr/ailment";
    license = with licenses; [ bsd2 ];
    maintainers = with maintainers; [ fab ];
  };
}
