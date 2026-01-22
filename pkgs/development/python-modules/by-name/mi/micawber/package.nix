{
  lib,
  buildPythonPackage,
  fetchPypi,
  beautifulsoup4,
}:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zATBml4Os2FbjNldWu/a1c3k9SphwS1FBxcn3+Ext2A=";
  };

  propagatedBuildInputs = [ beautifulsoup4 ];

  meta = {
    homepage = "https://micawber.readthedocs.io/en/latest/";
    description = "Module for extracting rich content from URLs";
    license = lib.licenses.mit;
    longDescription = ''
      micawber supplies a few methods for retrieving rich metadata
      about a variety of links, such as links to youtube videos.
      micawber also provides functions for parsing blocks of text and html
      and replacing links to videos with rich embedded content.
    '';
    maintainers = with lib.maintainers; [ davidak ];
  };
}
