{
  lib,
  fetchPypi,
  buildPythonPackage,
  click,
  pyyaml,
  setuptools,
  chardet,
  pytest,
  ujson,
}:

buildPythonPackage rec {
  pname = "mathics-scanner";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "mathics_scanner";
    inherit version;
    hash = "sha256-BCSuCRgxNkCvUqe7rckYJMoYaesa0ODdh8eEwUEybZo=";
  };

  build-system = [
    click
    pyyaml
    setuptools
  ];

  dependencies = [
    chardet
    click
    pyyaml
  ];

  optional-dependencies = {
    dev = [ pytest ];
    full = [ ujson ];
  };

  pythonImportsCheck = [ "mathics_scanner" ];

  meta = {
    description = "Character Tables and Tokenizer for Mathics and the Wolfram Language";
    homepage = "https://mathics.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mathics-scanner";
  };
}
