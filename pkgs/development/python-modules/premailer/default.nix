{ lib, buildPythonPackage, fetchPypi, isPy27,
  cssselect, cssutils, lxml, mock, nose, requests, cachetools
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.9.0";
  disabled = isPy27; # no longer compatible with urllib

  src = fetchPypi {
    inherit pname version;
    sha256 = "da18b9e8cb908893b67ab9b7451276fef7c0ab179f40189378545f6bb0ab3695";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cachetools cssselect cssutils lxml requests ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
  };
}
