{ lib
, buildPythonPackage
, marisa-trie
, pythonOlder
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "langcodes";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1axdiva2qglsjmnx2ak7i6hm0yhp6kbc4lcsgn8ckwy0nq1z3kr2";
  };

  propagatedBuildInputs = [ marisa-trie ];

  disabled = pythonOlder "3.3";

  checkInputs = [ nose ];

  checkPhase = ''
    nosetests
  '';

  meta = with lib; {
    description = "A toolkit for working with and comparing the standardized codes for languages, such as ‘en’ for English or ‘es’ for Spanish";
    homepage =  https://github.com/LuminosoInsight/langcodes;
    license = licenses.mit;
    maintainers = with maintainers; [ ixxie ];
  };
}
