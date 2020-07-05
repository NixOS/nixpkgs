{ lib, buildPythonPackage, fetchPypi,
  cssselect, cssutils, lxml, mock, nose, requests, cachetools
}:

buildPythonPackage rec {
  pname = "premailer";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5eec9603e84cee583a390de69c75192e50d76e38ef0292b027bd64923766aca7";
  };

  buildInputs = [ mock nose ];
  propagatedBuildInputs = [ cachetools cssselect cssutils lxml requests ];

  meta = {
    description = "Turns CSS blocks into style attributes ";
    homepage = "https://github.com/peterbe/premailer";
    license = lib.licenses.bsd3;
  };
}
