{ stdenv
, fetchPypi
, buildPythonPackage
, certifi
, future
, urllib3
, tornado
, pytest
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "12.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yrg5342zz0hpf2pc85ffwx57msa6jpcmvvjfkzh8nh2lc98aq21";
  };

  prePatch = ''
    rm -rf telegram/vendor
    substituteInPlace telegram/utils/request.py \
      --replace "import telegram.vendor.ptb_urllib3.urllib3 as urllib3" "import urllib3 as urllib3" \
      --replace "import telegram.vendor.ptb_urllib3.urllib3.contrib.appengine as appengine" "import urllib3.contrib.appengine as appengine" \
      --replace "from telegram.vendor.ptb_urllib3.urllib3.connection import HTTPConnection" "from urllib3.connection import HTTPConnection" \
      --replace "from telegram.vendor.ptb_urllib3.urllib3.util.timeout import Timeout" "from urllib3.util.timeout import Timeout"

    touch LICENSE.dual
  '';

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ certifi future urllib3 tornado ];

  # tests not included with release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "This library provides a pure Python interface for the Telegram Bot API.";
    homepage = https://python-telegram-bot.org;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ veprbl ];
  };
}
