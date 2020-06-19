{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.15.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb42ba62fbc048c91d5cf1ac729e0ea4ee329cc526bddafed4e7a8aa6b57fbbb";
  };

  propagatedBuildInputs = [ passlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
