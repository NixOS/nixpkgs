{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "2.1.0";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75bcaca8825e1a321965b136815dee53083c63314975e024ad0ccff8545e681f";
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
