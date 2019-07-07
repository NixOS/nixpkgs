{ stdenv, buildPythonPackage, fetchPypi, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "002g31h4fcrrlfcrcbqa94aggszadm0p91c28n19vgssinmbz0ia";
  };

  propagatedBuildInputs = [ beautifulsoup4 ];

  meta = with stdenv.lib; {
    homepage = http://micawber.readthedocs.io/en/latest/;
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
