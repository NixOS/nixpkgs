{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests, cachetools
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8240bfb8ff94db3ae581d8434b7eea5005872d5779394ed8f4223dfb0f58afd2";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cachetools cssselect cssutils lxml requests ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
  };
}
