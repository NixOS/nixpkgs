{ lib, fetchPypi, buildPythonPackage
, click, pytest
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "eb037a2dd95a9e20b3897c2b3ca57e7f6797f76a8d93f7eeedda7fcdcbc9b635";
  };

  propagatedBuildInputs = [ click ];

  # tries to use /homeless-shelter to mimic container usage, etc
  #doCheck = false;
  checkInputs = [ pytest ];

  pythonImportsCheck = [ "click_help_colors" ];

  meta = with lib; {
    description = "Colorization of help messages in Click";
    homepage    = "https://github.com/r-m-n/click-help-colors";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
