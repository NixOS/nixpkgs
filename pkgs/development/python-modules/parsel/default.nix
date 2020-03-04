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
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08v76s6s4li7asnyz8a7gbp9vz522rv5apranyv76mb0lhmjd92d";
  };

  checkInputs = [ pytest pytestrunner ];
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
