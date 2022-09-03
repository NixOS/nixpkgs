{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "langdetect";
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1805svvb7xjm4sf1j7b6nc3409x37pd1xmabfwwjf1ldkzwgxhfb";
  };

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "langdetect" ];

  meta = with lib; {
    description = "Python port of Google's language-detection library";
    homepage = "https://github.com/Mimino666/langdetect";
    license = licenses.asl20;
    maintainers = with maintainers; [ erikarvstedt ];
  };
}
