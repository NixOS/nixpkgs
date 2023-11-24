{ lib
, buildPythonPackage
, fetchPypi
, beautifulsoup4
, pythonOlder
}:

buildPythonPackage rec {
  pname = "micawber";
  version = "0.5.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CsWBS2X/KngfsTlLkaI6ipX3NJK2u49wW67q2C6t1UM=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
  ];

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
