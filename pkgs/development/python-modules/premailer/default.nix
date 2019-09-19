{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests, cachetools
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93be4f197e9d2a87a8fe6b5b6a79b64070dbb523108dfaf2a415b4558fc78ec1";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cachetools cssselect cssutils lxml requests ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };
}
