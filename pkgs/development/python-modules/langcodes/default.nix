{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "2.0.0";
  disabled = pythonOlder "3.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0xszgmydymzhb0dhx5qvdn3x5z477ld0paw17lwwhlrxffkq5jxz";
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
