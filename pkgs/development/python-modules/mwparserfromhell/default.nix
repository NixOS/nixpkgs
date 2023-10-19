{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mwparserfromhell";
  version = "0.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-K60L/2FFdjmeRHDWQAuinFLVlWgqS43mQq+7W+v0o0Y=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"pytest-runner"' ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mwparserfromhell"
  ];

  meta = with lib; {
    description = "MWParserFromHell is a parser for MediaWiki wikicode";
    homepage = "https://mwparserfromhell.readthedocs.io/";
    changelog = "https://github.com/earwig/mwparserfromhell/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ melling ];
  };
}
