{ stdenv
, fetchPypi
, buildPythonPackage
, certifi
, decorator
, future
, urllib3
, tornado
, pytest
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "12.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vwf4pgjrg9a6w51ds9wmzq31bmi3f7xs79gdzzfxfmqmy1hb2r1";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ certifi future urllib3 tornado decorator ];

  pipInstallFlags = "--install-option '--with-upstream-urllib3'";

  # tests not included with release
  doCheck = false;
  pythonImportsCheck = [ "telegram" ];

  meta = with stdenv.lib; {
    description = "This library provides a pure Python interface for the Telegram Bot API.";
    homepage = "https://python-telegram-bot.org";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ veprbl pingiun ];
  };
}
