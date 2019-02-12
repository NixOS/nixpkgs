{ stdenv
, buildPythonPackage
, fetchPypi
, six
, beautifulsoup4
, lxml
}:

buildPythonPackage rec {
  pname = "ofxparse";
  version = "0.20";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zn3grc6xhgzcc81qc3dxkkwk731cjjqqhb46smw12lk09cdnigb";
  };

  propagatedBuildInputs = [ six beautifulsoup4 lxml ];

  meta = with stdenv.lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
  };

}
