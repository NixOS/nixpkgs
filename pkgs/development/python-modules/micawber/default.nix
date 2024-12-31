{
  lib,
  buildPythonPackage,
  fetchPypi,
  beautifulsoup4,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-INxOB0wXp0GIC0ic8lWIRcBQmH9beWyP8H6i/wEajI0=";
  };

  propagatedBuildInputs = [ beautifulsoup4 ];

  meta = with lib; {
    homepage = "https://micawber.readthedocs.io/en/latest/";
    description = "Module for extracting rich content from URLs";
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
