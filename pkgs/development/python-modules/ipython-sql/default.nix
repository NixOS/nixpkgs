{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, ipython
, ipython-genutils
, pandas
, prettytable
, pytest
, sqlalchemy
, sqlparse
}:
buildPythonPackage rec {
  pname = "ipython-sql";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "catherinedevlin";
    repo = "ipython-sql";
    rev = "117764caf099d80100ed4b09fc004b55eed6f121";
    hash = "sha256-ScQihsvRSnC7VIgy8Tzi1z4x6KIZo0SAeLPvHAVdrfA=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace 'prettytable<1' prettytable
  '';

  propagatedBuildInputs = [
    ipython
    ipython-genutils
    prettytable
    sqlalchemy
    sqlparse
  ];

  nativeCheckInputs = [ ipython pandas pytest ];

  checkPhase = ''
    runHook preCheck

    # running with ipython is required because the tests use objects available
    # only inside of ipython, for example the global `get_ipython()` function
    ipython -c 'import pytest; pytest.main()'

    runHook postCheck
  '';

  pythonImportsCheck = [ "sql" ];

  meta = with lib; {
    description = "Introduces a %sql (or %%sql) magic.";
    homepage = "https://github.com/catherinedevlin/ipython-sql";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
