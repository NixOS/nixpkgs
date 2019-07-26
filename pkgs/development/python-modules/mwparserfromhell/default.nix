{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.5.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aaf5416ab9b75e99e286f8a4216f77a2f7d834afd4c8f81731e701e59bf99305";
  };

  meta = with stdenv.lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
  };
}
