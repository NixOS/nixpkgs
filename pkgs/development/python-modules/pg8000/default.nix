{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.12.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fbgwka1zc9s8ds6fmr68c5n87ykf45bgd4bj0ka7zcyiqaijflh";
  };

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mfenniak/pg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.linux;
  };

}
