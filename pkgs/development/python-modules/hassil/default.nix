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
  version = "0.1.3";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KWkzHWMo50OIrZ2kwFhhqDSleFFkAD7/JugjvSyCkww=";
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
