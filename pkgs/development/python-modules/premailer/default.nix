{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.2.0";

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca97cec6115fea6590b49558c55d891996f9eb4da6490c7b60c3a8af4c8c0735";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cssselect cssutils lxml requests ];
}
