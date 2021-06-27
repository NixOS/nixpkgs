{ lib
, APScheduler
, buildPythonPackage
, cachetools
, certifi
, decorator
, fetchPypi
, future
, tornado
, urllib3
, pythonOlder
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "13.6";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37cfe8faba16fb68a8b5ab41a10e787c385f6296200c84256cc54d7c16334643";
  };

  propagatedBuildInputs = [
    APScheduler
    cachetools
    certifi
    decorator
    future
    tornado
    urllib3
  ];

  # --with-upstream-urllib3 is not working properly
  postPatch = ''
    rm -r telegram/vendor

    substituteInPlace requirements.txt \
      --replace 'APScheduler==3.6.3' 'APScheduler'
  '';

  setupPyGlobalFlags = "--with-upstream-urllib3";

  # tests not included with release
  doCheck = false;
  pythonImportsCheck = [ "telegram" ];

  meta = with lib; {
    description = "Python library to interface with the Telegram Bot API";
    homepage = "https://python-telegram-bot.org";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ veprbl pingiun ];
  };
}
