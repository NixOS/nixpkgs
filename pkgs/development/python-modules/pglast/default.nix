{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "3.13";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-H1IVoXBanNlmjUMhBHRbnBsbeK9LuruqXJaVgSgCFPo=";
  };

  propagatedBuildInputs = [
    setuptools
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=pglast --cov-report term-missing" ""
  '';

  checkInputs = [
    pytest
  ];

  # pytestCheckHook doesn't work
  # ImportError: cannot import name 'parse_sql' from 'pglast'
  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/lelit/pglast";
    description = "PostgreSQL Languages AST and statements prettifier";
    changelog = "https://github.com/lelit/pglast/raw/v${version}/CHANGES.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ marsam ];
  };
}
