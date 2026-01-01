{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  beautifulsoup4,
  lxml,
}:

buildPythonPackage rec {
  pname = "ofxparse";
  version = "0.21";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19y4sp5l9jqiqzzlbqdfiab42qx7d84n4xm4s7jfq397666vcyh5";
  };

  propagatedBuildInputs = [
    six
    beautifulsoup4
    lxml
  ];

<<<<<<< HEAD
  meta = {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
