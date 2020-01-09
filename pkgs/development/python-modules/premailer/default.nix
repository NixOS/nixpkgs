{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests, cachetools
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "08pshx7a110k4ll20x0xhpvyn3kkipkrbgxjjn7ncdxs54ihdhgw";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cachetools cssselect cssutils lxml requests ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = https://github.com/peterbe/premailer;
    license = lib.licenses.bsd3;
  };
}
