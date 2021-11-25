{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.2.1";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "779a6da5036f87b6b56c180b2782ab111ddd6aa9157670a9b918402b0e07cd93";
  };

  propagatedBuildInputs = [ marisa-trie ];

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "A toolkit for working with and comparing the standardized codes for languages, such as ‘en’ for English or ‘es’ for Spanish";
    homepage =  "https://github.com/LuminosoInsight/langcodes";
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
