{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, functools32
, six
, w3lib
, lxml
, cssselect
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9ccd82b8a122345601f6f9209e972c0e8c3518a188fcff2d37cb4d7bc570b4b8";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ functools32 six w3lib lxml cssselect ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/scrapy/parsel";
    description = "Parsel is a library to extract data from HTML and XML using XPath and CSS selectors";
    license = licenses.bsd3;
  };

}
