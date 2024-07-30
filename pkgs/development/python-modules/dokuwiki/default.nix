{
  lib,
  fetchPypi,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "dokuwiki";
  version = "1.3.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gtTyO6jmjQT0ZwmxvH+RAe1v5aruNStfP1qz1+AqYXs=";
  };

  pythonImportsCheck = [ "dokuwiki" ];

  meta = with lib; {
    homepage = "https://github.com/fmenabe/python-dokuwiki";
    description = "Python module that aims to manage DokuWiki wikis by using the provided XML-RPC API";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ];
  };
}
