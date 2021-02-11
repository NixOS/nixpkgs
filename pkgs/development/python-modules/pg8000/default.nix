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
    sha256 = "14198c5afeb289106e40ee6e5e4c0529c5369939f6ca588a028b371a75fe20dd";
  };

  propagatedBuildInputs = [ passlib scramp ];

  meta = with lib; {
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
