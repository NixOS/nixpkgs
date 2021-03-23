{ lib
, buildPythonPackage
, fetchPypi
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.18.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nkjxf95ldda41mkmahbikhd1fvxai5lfjb4a5gyhialpz4g5fim";
  };

  propagatedBuildInputs = [ passlib scramp ];

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
