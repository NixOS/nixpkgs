{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "jsmin";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fsmqbjvpxvff0984x7c0y8xmf49ax9mncz48b9xjx8wrnr9kpxn";
  };

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = https://github.com/tikitu/jsmin/;
    license = licenses.mit;
  };
}
