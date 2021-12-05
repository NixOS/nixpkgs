{ lib, aiohttp, aioresponses, buildPythonPackage, fetchFromGitHub
, pytest-asyncio, pytestCheckHook, python-dateutil, pythonOlder, pytz }:

buildPythonPackage rec {
  pname = "py-nightscout";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marciogranzotto";
    repo = pname;
    rev = "v${version}";
    sha256 = "06i8vc7ykk5112y66cjixbrks46mdx3r0ygkmyah6gfgq1ddc39j";
  };

  propagatedBuildInputs = [ python-dateutil pytz aiohttp ];

  checkInputs = [ aioresponses pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [ "py_nightscout" ];

  meta = with lib; {
    description = "Python library that provides an interface to Nightscout";
    homepage = "https://github.com/marciogranzotto/py-nightscout";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
