{ lib
, buildPythonPackage
, fetchPypi

# propagates
, antlr4-python3-runtime
, dataclasses-json
, pyyaml

# tests
, pytestCheckHook
}:

let
  pname = "hassil";
  version = "0.1.4";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ygaPdfH2jBk2xvlgt7V8/VcZAtv6Lwsi8g+stK/DdT8=";
  };

  postPatch = ''
    sed -i 's/antlr4-python3-runtime==.*/antlr4-python3-runtime/' requirements.txt
  '';

  propagatedBuildInputs = [
    antlr4-python3-runtime
    dataclasses-json
    pyyaml
  ];

  checkInputs = [
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
