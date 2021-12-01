{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-runner
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ad779f1bc0808d280ec1026c9de74f424de535568e21debd12830b5b0fa097e";
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
