{ lib
, buildPythonPackage
, fetchPypi
, mwlib
, mwlib-ext
, pygments
}:

buildPythonPackage rec {
  version = "0.14.5";
  pname = "mwlib.rl";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dddf9603ea0ca5aa87890217709eb5a5b16baeca547db3daad43c3ace73b6bc1";
  };

  buildInputs = [ mwlib mwlib-ext pygments ];

  meta = with lib; {
    description = "Generate pdfs from mediawiki markup";
    homepage = "http://pediapress.com/code/";
    license = licenses.bsd3;
  };

}
