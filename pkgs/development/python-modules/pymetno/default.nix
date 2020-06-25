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
  version = "0.5.1";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Danielhiversen";
    rev = version;
    sha256 = "1ihq1lzgzcxbg916izakx9jp0kp1vdrcdwcwwwsws838wc08ax6m";
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
