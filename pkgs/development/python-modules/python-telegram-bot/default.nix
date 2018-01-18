{ stdenv, fetchPypi, buildPythonPackage, isPy3k, certifi, future }:

buildPythonPackage rec {
  pname = "python-telegram-bot";
  version = "9.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a5b4wfc6ms7kblynw2h3ygpww98kyz5n8iibqbdyykwx8xj7hzm";
  };

  propagatedBuildInputs = [ certifi future ];
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "This library provides a pure Python interface for the Telegram Bot API.";
    homepage = https://python-telegram-bot.org;
    license = licenses.lgpl3;
    maintainers = with maintainers; [ veprbl ];
  };
}
