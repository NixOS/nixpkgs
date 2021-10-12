{ lib
, buildPythonPackage
, fetchPypi
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.21.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f73f1d477cda12a7b784be73c8a0c06c71e4284ef90cae4883cbc7c524b95fbf";
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
