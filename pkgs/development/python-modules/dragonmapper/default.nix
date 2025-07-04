{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  unittestCheckHook,
  hanzidentifier,
  zhon,
}:

buildPythonPackage rec {
  pname = "dragonmapper";
  version = "0.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tsroten";
    repo = "dragonmapper";
    tag = "v${version}";
    hash = "sha256-/02vcjcsUpQA1R1hcp34g/MSzNrKwuEyY5ERQQ5Vemw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hanzidentifier
    zhon
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "dragonmapper" ];

  meta = {
    description = "Identification and conversion functions for Chinese text processing";
    homepage = "https://github.com/tsroten/dragonmapper";
    changelog = "https://github.com/tsroten/dragonmapper/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ShamrockLee ];
  };
}
