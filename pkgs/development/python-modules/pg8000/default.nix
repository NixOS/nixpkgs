{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.13.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "2208c7aaffe8d61f5c4ccbefeb74ba033003899e64aee37c0eb98aadae8b9c6b";
  };

  propagatedBuildInputs = [ passlib ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tlocke/pg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.unix;
  };

}
