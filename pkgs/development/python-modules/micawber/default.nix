{ lib, buildPythonPackage, fetchPypi, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05ef4c89e307e3031dd1d85a3a557cd7f9f900f7dbbbcb33dde454940ca38460";
  };

  propagatedBuildInputs = [ beautifulsoup4 ];

  meta = with lib; {
    homepage = "https://micawber.readthedocs.io/en/latest/";
    description = "A small library for extracting rich content from urls";
    license = licenses.mit;
    longDescription = ''
      micawber supplies a few methods for retrieving rich metadata
      about a variety of links, such as links to youtube videos.
      micawber also provides functions for parsing blocks of text and html
      and replacing links to videos with rich embedded content.
    '';
    maintainers = with maintainers; [ davidak ];
  };
}
