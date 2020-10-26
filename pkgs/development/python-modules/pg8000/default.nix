{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.16.5";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8af70cdfcc1fadafa32468a6af563e1c0b5271c4dcc99a4490030a128cb295a3";
  };

  propagatedBuildInputs = [ passlib ];

  meta = with stdenv.lib; {
    broken = true;
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
