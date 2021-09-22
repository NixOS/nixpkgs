{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-k5XxPLpCB0TFoxVjjjNIwF3b7suedh3tIGyJ7rim2wo=";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
