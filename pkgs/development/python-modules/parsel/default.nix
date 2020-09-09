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
, isPy27
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0yawf9r3r863lwxj0n89i7h3n8xjbsl5b7n6xg76r68scl5yzvvh";
  };

  checkInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six w3lib lxml cssselect ] ++ lib.optionals isPy27 [ functools32 ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    homepage = "https://github.com/scrapy/parsel";
    description = "Parsel is a library to extract data from HTML and XML using XPath and CSS selectors";
    license = licenses.bsd3;
  };

}
