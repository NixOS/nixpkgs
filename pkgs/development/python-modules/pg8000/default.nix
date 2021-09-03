{ lib
, buildPythonPackage
, fetchPypi
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.21.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HMvuyTtw4uhTLfOr3caQXHghkJyW3Oqu91G1fFKRhpo=";
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
