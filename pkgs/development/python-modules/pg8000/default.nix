{ lib
, buildPythonPackage
, fetchPypi
, scramp
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.17.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-FBmMWv6yiRBuQO5uXkwFKcU2mTn2yliKAos3GnX+IN0=";
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
