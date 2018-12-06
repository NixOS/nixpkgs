{ stdenv
, buildPythonPackage
, fetchPypi
, six
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "ofxparse";
  version = "0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d8c486126a94d912442d040121db44fbc4a646ea70fa935df33b5b4dbfbbe42a";
  };

  propagatedBuildInputs = [ six beautifulsoup4 ];

  meta = with stdenv.lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
  };

}
