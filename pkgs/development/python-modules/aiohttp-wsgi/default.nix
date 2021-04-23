{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-wsgi";
  version = "0.8.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "etianen";
    repo = pname;
    rev = version;
    sha256 = "0wirn3xqxxgkpy5spicd7p1bkdnsrch61x2kcpdwpixmx961pq7x";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiohttp_wsgi" ];

  meta = with lib; {
    description = "WSGI adapter for aiohttp";
    homepage = "https://github.com/etianen/aiohttp-wsgi";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
