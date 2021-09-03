{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "3.8.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afdd887fff42a963f13d09a1f4f5fd24aef08f4b8a594f2ac11e0a29022f1518";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
