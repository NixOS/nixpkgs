{ lib, buildPythonPackage, fetchPypi, aiohttp, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cf9338b8bdcc57e49a6d11b2492d8661c708bda165ab21940404b2db8c52ad6";
  };

  propagatedBuildInputs = [ aiohttp requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
