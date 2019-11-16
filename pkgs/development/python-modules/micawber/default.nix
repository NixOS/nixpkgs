{ stdenv, buildPythonPackage, fetchPypi, beautifulsoup4 }:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5e1e6fbab5bfc1edc6d575b900707c24a3484c51cf2e01f059a7e070724a3633";
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
