{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fwXOfQW+ybhROdgayOAsgaFjf8HHh5jr5xczkBnA40w=";
  };

  disabled = !isPy3k;

  # ModuleNotFoundError: No module named 'pkg_resources'
  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov=pglast --cov-report term-missing" ""
  '';

  checkInputs = [ pytest ];

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
    maintainers = [ maintainers.marsam ];
  };
}
