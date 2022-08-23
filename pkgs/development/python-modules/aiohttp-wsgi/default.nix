{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-wsgi";
  version = "0.10.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "etianen";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-3Q00FidZWV1KueuHyHKQf1PsDJGOaRW6v/kBy7lzD4Q=";
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
