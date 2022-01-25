{ lib, buildPythonPackage, fetchPypi, aiohttp, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0405d1c6c60e6603594e9319c28d31b97abe49afe9af21d230f5072a1d38976";
  };

  propagatedBuildInputs = [ aiohttp requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
