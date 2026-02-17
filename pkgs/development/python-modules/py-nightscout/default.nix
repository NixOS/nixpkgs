{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "py-nightscout";
  version = "1.3.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "marciogranzotto";
    repo = "py-nightscout";
    rev = "v${version}";
    sha256 = "0kslmm3wrxhm307nqmjmq8i8vy1x6mjaqlgba0hgvisj6b4hx65k";
  };

  propagatedBuildInputs = [
    python-dateutil
    pytz
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "py_nightscout" ];

  meta = {
    description = "Python library that provides an interface to Nightscout";
    homepage = "https://github.com/marciogranzotto/py-nightscout";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
