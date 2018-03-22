{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests
}:

buildPythonPackage rec {
  pname = "premailer";
  name = "${pname}-${version}";
  version = "3.1.1";

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "fd07dadc47345f7d44a0587bd65a37c45886f19c44b3ec94904761e4b2d39124";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cssselect cssutils lxml requests ];
}
