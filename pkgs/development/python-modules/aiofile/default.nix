{ lib
, aiomisc
, asynctest
, caio
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiofile";
  version = "3.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PIImQZ1ymazsOg8qmlO91tNYHwXqK/d8AuKPsWYvh0w=";
  };

  propagatedBuildInputs = [
    caio
  ];

  checkInputs = [
    aiomisc
    asynctest
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "aiofile"
  ];

  meta = with lib; {
    description = "File operations with asyncio support";
    homepage = "https://github.com/mosquito/aiofile";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
