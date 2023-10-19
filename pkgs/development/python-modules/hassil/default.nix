{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, importlib-resources
, pyyaml

# tests
, pytestCheckHook
}:

let
  pname = "hassil";
  version = "1.2.5";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-udOkZILoba2+eR8oSFThsB846COaIXawwRYhn261mCA=";
  };

  propagatedBuildInputs = [
    pyyaml
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog  = "https://github.com/home-assistant/hassil/releases/tag/v${version}";
    description = "Intent parsing for Home Assistant";
    homepage = "https://github.com/home-assistant/hassil";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
