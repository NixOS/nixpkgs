{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-runner
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d3f74c0101f81ff73c61985b67f2e7048a30dc5f6a578ea1544e69133988d874";
  };

  checkInputs = [
    pytestCheckHook
    pytest-runner
  ];

  meta = with lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/en/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
  };
}
