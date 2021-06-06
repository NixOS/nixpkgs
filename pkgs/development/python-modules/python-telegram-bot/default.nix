{ lib
, APScheduler
, buildPythonPackage
, certifi
, decorator
, fetchPypi
, future
, isPy3k
, tornado
, urllib3
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "13.5";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g9v0zUYyf9gYu2ZV8lCAJKCt5o69s1RNo1xGmtwjvds=";
  };

  propagatedBuildInputs = [
    APScheduler
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
