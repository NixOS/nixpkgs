{ lib
, buildPythonPackage
, numpy
, six
, nose
, fetchPypi
}:

buildPythonPackage rec {
  pname = "py_stringmatching";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-khubsWOzEN80HDOCORMgT3sMqfajGfW0UUCDAL03je4=";
  };

  nativeCheckInputs = [ nose ];

  propagatedBuildInputs = [ numpy six ];

  meta = with lib; {
    description = "Python string matching library including string tokenizers and string similarity measures";
    homepage = "https://github.com/anhaidgroup/py_stringmatching";
    changelog = "https://github.com/anhaidgroup/py_stringmatching/blob/v${version}/CHANGES.txt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ixxie ];
  };
}
