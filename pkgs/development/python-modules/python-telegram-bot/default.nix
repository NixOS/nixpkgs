{ lib
, fetchPypi
, buildPythonPackage
, certifi
, decorator
, future
, urllib3
, tornado
, pytest
, APScheduler
, isPy3k
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "13.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dw1sGfdeUw3n9qh4TsBpRdqEvNI0SnKTK4wqBaeM1CE=";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ certifi future urllib3 tornado decorator APScheduler ];

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
    description = "This library provides a pure Python interface for the Telegram Bot API.";
    homepage = "https://python-telegram-bot.org";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ veprbl pingiun ];
  };
}
