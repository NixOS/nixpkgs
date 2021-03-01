{ lib
, buildPythonPackage
, fetchPypi
, scramp
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.16.6";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8fc1e6a62ccb7c9830f1e7e9288e2d20eaf373cc8875b5c55b7d5d9b7717be91";
  };

  propagatedBuildInputs = [ passlib scramp ];

  meta = with lib; {
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
