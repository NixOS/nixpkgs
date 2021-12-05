{ lib, buildPythonPackage, fetchPypi, requests }:

buildPythonPackage rec {
  pname = "pyTelegramBotAPI";
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05f85dacbcf0bdf2459698bab4325f3a699d1c04bc61581627d76d075c3d5488";
  };

  propagatedBuildInputs = [ requests ];

  meta = with lib; {
    homepage = "https://github.com/eternnoir/pyTelegramBotAPI";
    description =
      "A simple, but extensible Python implementation for the Telegram Bot API";
    license = licenses.gpl2;
    maintainers = with maintainers; [ das_j ];
  };
}
