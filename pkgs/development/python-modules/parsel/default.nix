{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, pytestrunner
, six
, w3lib
, lxml
, cssselect
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a34d1c0bj1fzb5dk5744m2ag6v3b8glk4xp0amqxdan9ldbcd97";
  };

  buildInputs = [ pytest pytestrunner ];
  propagatedBuildInputs = [ six w3lib lxml cssselect ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/scrapy/parsel";
    description = "Parsel is a library to extract data from HTML and XML using XPath and CSS selectors";
    license = licenses.bsd3;
  };

}
