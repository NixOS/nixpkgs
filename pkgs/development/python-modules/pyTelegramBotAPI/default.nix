{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, requests
, fastapi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6nfpXzq2yCVDK8pAuWzAVzr0pKn5VHqb3UH9VXhSHJ0=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
    fastapi
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
