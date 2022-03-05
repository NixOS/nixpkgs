{ lib, buildPythonPackage, fetchPypi, aiohttp, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5vIjVqvr/+Cok9z3L+CaDIve2tb0mMVaMMPdMs5Ijmo=";
  };

  propagatedBuildInputs = [ aiohttp requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
