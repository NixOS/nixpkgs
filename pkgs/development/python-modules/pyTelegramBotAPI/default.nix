{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "3.7.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7774314ff429852d423d5dfebe8fc1011dca93a028f1ccb0c56db6817245b752";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
