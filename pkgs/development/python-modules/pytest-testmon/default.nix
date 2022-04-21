{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, coverage
, pytest
}:

buildPythonPackage rec {
  pname = "pytest-testmon";
  version = "1.3.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6gWWCtm/GHknhjLyRdVf42koeaSKzk5/V0173DELmj0=";
  };

  propagatedBuildInputs = [ pytest coverage ];

  # The project does not include tests since version 1.3.0
  doCheck = false;
  pythonImportsCheck = [ "testmon" ];

  meta = with lib; {
    homepage = "https://github.com/tarpas/pytest-testmon/";
    description = "This is a py.test plug-in which automatically selects and re-executes only tests affected by recent changes";
    license = licenses.mit;
    maintainers = [ maintainers.dmvianna ];
  };
}

