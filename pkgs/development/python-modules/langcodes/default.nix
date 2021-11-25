{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "3.3.0";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "794d07d5a28781231ac335a1561b8442f8648ca07cd518310aeb45d6f0807ef6";
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
