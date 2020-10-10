{ stdenv
, buildPythonPackage
, fetchFromGitHub
, aiohttp
, async-timeout
, pytz
, xmltodict
}:

buildPythonPackage rec {
  pname = "PyMetno";
  version = "0.8.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Danielhiversen";
    rev = version;
    sha256 = "1jngf0mbn5hn166pqh1ga5snwwvv7n5kv1k9kaksrfibixkvpw6h";
  };

  propagatedBuildInputs = [ aiohttp async-timeout pytz xmltodict ];

  pythonImportsCheck = [ "metno"];

  meta = with stdenv.lib; {
    description = "A library to communicate with the met.no api";
    homepage = "https://github.com/Danielhiversen/pyMetno/";
    license = licenses.mit;
    maintainers = with maintainers; [ flyfloh ];
  };
}
