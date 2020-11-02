{ stdenv, fetchPypi, buildPythonPackage
, click, pytest
}:

buildPythonPackage rec {
  pname = "click-help-colors";
  version = "0.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "EZ5fr2nPyRnJlcWWIyasj9h/EeVqNxr1lOPf2EWPTG4=";
  };

  propagatedBuildInputs = [ click ];

  # tries to use /homeless-shelter to mimic container usage, etc
  #doCheck = false;
  checkInputs = [ pytest ];

  pythonImportsCheck = [ "click_help_colors" ];

  meta = with stdenv.lib; {
    description = "Colorization of help messages in Click";
    homepage    = "https://github.com/r-m-n/click-help-colors";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
