{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "3.7.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ce42d84442ff2ce4918de6550cf377253f61e28e4fac2634495683d12df66d00";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description = "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
