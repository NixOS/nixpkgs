{ stdenv, fetchPypi, buildPythonPackage, certifi, future, urllib3 }:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "10.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca2f8a44ddef7271477e16f4986647fa90ef4df5b55a7953e53b9c9d2672f639";
  };

  prePatch = ''
    rm -rf telegram/vendor
    substituteInPlace telegram/utils/request.py \
      --replace "import telegram.vendor.ptb_urllib3.urllib3 as urllib3" "import urllib3 as urllib3" \
      --replace "import telegram.vendor.ptb_urllib3.urllib3.contrib.appengine as appengine" "import urllib3.contrib.appengine as appengine" \
      --replace "from telegram.vendor.ptb_urllib3.urllib3.connection import HTTPConnection" "from urllib3.connection import HTTPConnection" \
      --replace "from telegram.vendor.ptb_urllib3.urllib3.util.timeout import Timeout" "from urllib3.util.timeout import Timeout"
  '';

  propagatedBuildInputs = [ certifi future urllib3 ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "This library provides a pure Python interface for the Telegram Bot API.";
    homepage = https://python-telegram-bot.org;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ veprbl ];
  };
}
