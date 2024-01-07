{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, pyyaml
, unicode-rbnf

# tests
, pytestCheckHook
}:

let
  pname = "hassil";
  version = "1.5.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GLvDT8BUBvEzgiqKaXokF912g3fOH+KsXnmeOXIwe9U=";
  };

  propagatedBuildInputs = [
    pyyaml
    unicode-rbnf
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog  = "https://github.com/home-assistant/hassil/blob/v${version}/CHANGELOG.md";
    description = "Intent parsing for Home Assistant";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
