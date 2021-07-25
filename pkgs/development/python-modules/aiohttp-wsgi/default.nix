{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-wsgi";
  version = "0.9.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "etianen";
    repo = pname;
    rev = version;
    sha256 = "sha256-lQ0mAUqsOmozUIMd6nwRATaq8C5SUFGoyQu1v0RBnas=";
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
