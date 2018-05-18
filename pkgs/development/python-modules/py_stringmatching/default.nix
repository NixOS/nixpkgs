{ lib
, buildPythonPackage
, numpy
, six
, nose
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py_stringmatching";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rjsx7iipn6svki21lmsza7b0dz9vkgmix696zryiv7gkhblqyb4";
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
