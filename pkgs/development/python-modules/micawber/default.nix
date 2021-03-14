{ lib, buildPythonPackage, fetchPypi, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ac2d737d8ff27ed01ea3825ed8806970e8137d7b342cef37b39b6dd17e6eb3a4";
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
