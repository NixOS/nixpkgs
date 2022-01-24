{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "pglast";
  version = "3.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "31ad29b6a27048b1a26c072992fc5213d2eaf366854679e6c97111e300e0ef01";
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
