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
  version = "0.5.0";

  src = fetchFromGitHub {
    repo = pname;
    owner = "Danielhiversen";
    rev = version;
    sha256 = "00v2r3nn48svni9rbmbf0a4ylgfcf93gk2wg7qnm1fv1qrkgscvg";
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
