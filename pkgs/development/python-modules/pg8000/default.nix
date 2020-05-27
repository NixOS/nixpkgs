{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
, passlib
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.13.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "eebcb4176a7e407987e525a07454882f611985e0becb2b73f76efb93bbdc0aab";
  };

  propagatedBuildInputs = [ passlib ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/tlocke/pg8000";
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}
