{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.29.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gLT03ksCVIMreUhRHg3UY0LRwERszU/diStj0C5PvHs=";
  };

  propagatedBuildInputs = [
    passlib
    scramp
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  postPatch = ''
    sed '/^\[metadata\]/a version = ${version}' setup.cfg
  '';

  # Tests require a running PostgreSQL instance
  doCheck = false;

  pythonImportsCheck = [
    "pg8000"
  ];

  meta = with lib; {
    description = "Python driver for PostgreSQL";
    homepage = "https://github.com/tlocke/pg8000";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };
}
