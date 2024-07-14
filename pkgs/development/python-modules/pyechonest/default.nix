{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "pyechonest";
  version = "9.0.0";
  format = "setuptools";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HaSzuLRXIyp+s1tZpIOQs8IIdZsB1ZasqnHmoXK0BJU=";
  };

  meta = with lib; {
    description = "Tap into The Echo Nest's Musical Brain for the best music search, information, recommendations and remix tools on the web";
    homepage = "https://github.com/echonest/pyechonest";
  };
}
