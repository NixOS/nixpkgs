{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.0.0";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e079053da0570b5a4124476065a589d14bf2ad4f376c6d84fd608e46070e45e5";
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
