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
    sha256 = "903a19158e9efda326908bb4b70a71d31f640b4326576774433ab11fd4e46f39";
  };

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mfenniak/pg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.unix;
  };

}
