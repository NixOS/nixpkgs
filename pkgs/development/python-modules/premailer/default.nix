{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests
}:

buildPythonPackage rec {
  pname = "premailer";
  name = "${pname}-${version}";
  version = "3.0.1";

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cmlvqx1dvy16k5q5ylmr43nlfpb9k2zl3q7s4kzhf0lml4wqwaf";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cssselect cssutils lxml requests ];
}
