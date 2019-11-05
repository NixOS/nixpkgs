{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.12.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1yc3knh28cx3rjb2ifg5kmqqa78yyyw2gzzslbm9fj0mzh5aq1sx";
  };

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/tlocke/pg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ domenkozar ];
    platforms = platforms.unix;
  };

}

