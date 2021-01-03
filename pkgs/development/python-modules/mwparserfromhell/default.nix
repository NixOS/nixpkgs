{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75787b6ab140ab267b313d37d045f3276f5dc6a9741074eddfbabc1635cb2efc";
  };

  meta = with stdenv.lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
  };
}
