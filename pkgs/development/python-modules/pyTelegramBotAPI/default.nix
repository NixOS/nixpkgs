{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CbeBkTxQz7ol5Gwy42vBOoC1X5l2hOT4bO1gMJ7Bgfs=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  pythonImportsCheck = [
    "telebot"
  ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ das_j ];
  };
}
