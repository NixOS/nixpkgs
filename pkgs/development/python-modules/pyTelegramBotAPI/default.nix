{ lib, buildPythonPackage, fetchPypi, aiohttp, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3Qppp/UDKiGChnvMOgW8EKygI75gYzv37c0ctExmK+g=";
  };

  propagatedBuildInputs = [ aiohttp requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
