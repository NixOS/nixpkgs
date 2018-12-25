{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
, six
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.12.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "18192d90409a3037619ef17f1924e3fd9c7169c9c1b3277cec1982116ec2b6de";
  };

  propagatedBuildInputs = [ pytz six ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mfenniak/pg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.linux;
  };

}
