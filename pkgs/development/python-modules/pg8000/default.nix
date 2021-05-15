{ lib
, buildPythonPackage
, fetchPypi
, passlib
, pythonOlder
, scramp
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.19.4";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fJxtV1QbDyFT4jqNdZzrPXy5MIkY+6atnpL44OWpC8g=";
  };

  propagatedBuildInputs = [
    passlib
    scramp
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "scramp==1.4.0" "scramp>=1.4.0"
  '';

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
