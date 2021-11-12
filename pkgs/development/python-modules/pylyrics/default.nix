{ lib, buildPythonPackage, fetchPypi, beautifulsoup4, requests }:

buildPythonPackage rec {
  pname = "pylyrics";
  version = "1.1.0";

  src = fetchPypi {
    pname = "PyLyrics";
    inherit version;
    extension = "zip";
    sha256 = "sha256-xfNujvDtO0h6kkLONMGfloTkGKW7/9XTZ9wdFgS0zQs=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
    requests
  ];

  pythonImportsCheck = [ "PyLyrics" ];

  # tries to connect to lyrics.wikia.com
  doCheck = false;

  meta = with lib; {
    description = "A Pythonic Implementation of lyrics.wikia.com for getting lyrics of songs ";
    homepage = "https://github.com/geekpradd/PyLyrics";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
