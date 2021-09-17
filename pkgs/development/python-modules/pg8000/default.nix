{ lib
, buildPythonPackage
, fetchPypi
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.21.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36a3b517408334967c1fa0d29656da03608d63122a372ec92c85f49aed2d24e3";
  };

  propagatedBuildInputs = [
    passlib
    scramp
  ];

  # Tests require a running PostgreSQL instance
  doCheck = false;
  pythonImportsCheck = [ "pg8000" ];

  meta = with lib; {
    description = "Python driver for PostgreSQL";
    homepage = "https://github.com/tlocke/pg8000";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };
}
