{ lib
, buildPythonPackage
, numpy
, six
, nose
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py_stringmatching";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c87f62698fba1612a18f8f44bd57f0c4e70aac2d7ca6dfb6ed46dabd2194453c";
  };

  nativeCheckInputs = [ nose ];

  propagatedBuildInputs = [ numpy six ];

  meta = with lib; {
    description = "A Python string matching library including string tokenizers and string similarity measures";
    homepage =  "https://sites.google.com/site/anhaidgroup/projects/magellan/py_stringmatching";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
