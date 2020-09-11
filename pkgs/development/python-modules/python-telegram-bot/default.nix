{ stdenv
, fetchPypi
, buildPythonPackage
, certifi
, decorator
, future
, urllib3
, tornado
, pytest
, isPy3k
}:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "12.8";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hzdnjxqgqv868agaipga4padq2q5s4hd1yzvh3n48b9ck2qcw9j";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ certifi future urllib3 tornado decorator ];

  # --with-upstream-urllib3 is not working properly
  postPatch = ''
    rm -rf telegram/vendor
  '';
  setupPyGlobalFlags = "--with-upstream-urllib3";

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
