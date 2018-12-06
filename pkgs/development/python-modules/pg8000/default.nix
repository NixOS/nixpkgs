{ stdenv
, buildPythonPackage
, fetchPypi
, pytz
}:

buildPythonPackage rec {
  pname = "pg8000";
  version = "1.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "188658db63c2ca931ae1bf0167b34efaac0ecc743b707f0118cc4b87e90ce488";
  };

  propagatedBuildInputs = [ pytz ];

  meta = with stdenv.lib; {
    homepage = https://github.com/realazthat/aiopg8000;
    description = "PostgreSQL interface library, for asyncio";
    maintainers = with maintainers; [ garbas domenkozar ];
    platforms = platforms.linux;
  };

}
