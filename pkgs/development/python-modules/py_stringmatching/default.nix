{ lib
, buildPythonPackage
, numpy
, six
, nose
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py_stringmatching";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c46db1e855cef596dfbbe1bd48fcabb30736479eff602c2bf88af10f998f1532";
  };

  checkInputs = [ nose ];
   
  propagatedBuildInputs = [ numpy six ];

  meta = with lib; {
    description = "A Python string matching library including string tokenizers and string similarity measures";
    homepage =  https://sites.google.com/site/anhaidgroup/projects/magellan/py_stringmatching;
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
