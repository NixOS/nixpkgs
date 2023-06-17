{ lib, buildPythonPackage, fetchPypi, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "003c5345aafe84f6b60fd289c003e8b1fef04c14e015c2d52d792a6b88135c89";
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
