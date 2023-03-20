{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-runner
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.6.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kr7JUorjTScok8yvK1J9+FwxT/KM+7MFY0BGewldg0w=";
  };

  nativeCheckInputs = [
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
