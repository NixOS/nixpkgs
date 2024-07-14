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
    hash = "sha256-BXq2jTEnDezk0aR2Yglqp2NBloqu4UX/xxHLRMvVxKc=";
  };

  propagatedBuildInputs = [
    six
    beautifulsoup4
    lxml
  ];

  meta = with lib; {
    homepage = "http://sites.google.com/site/ofxparse";
    description = "Tools for working with the OFX (Open Financial Exchange) file format";
    license = licenses.mit;
  };
}
