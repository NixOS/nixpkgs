{ stdenv
, buildPythonPackage
, fetchPypi
, six
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "ofxparse";
  version = "0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8c81fd5089332106da1a2e8919c412c7c677f08af04d557ca767701a04e0918";
  };

  propagatedBuildInputs = [ six beautifulsoup4 ];

  meta = with stdenv.lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
  };

}
