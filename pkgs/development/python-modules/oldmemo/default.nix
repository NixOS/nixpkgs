{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  typing-extensions,
  xeddsa,
  doubleratchet,
  omemo,
  x3dh,
  cryptography,
  protobuf,

  xmlschema,
}:

buildPythonPackage rec {
  pname = "oldmemo";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-oldmemo";
    tag = "v${version}";
    hash = "sha256-upgpyNoyBUg4IskF2DeQGOwm2h+hydO9lBoIHgwho28=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    typing-extensions
    xeddsa
    doubleratchet
    omemo
    x3dh
    cryptography
    protobuf
  ];

  optional-dependencies.xml = [
    xmlschema
  ];

  pythonImportsCheck = [
    "oldmemo"
  ];

  meta = {
    description = "Backend implementation of the `eu.siacs.conversations.axolotl` namespace for python-omemo";
    homepage = "https://github.com/Syndace/python-oldmemo";
    changelog = "https://github.com/Syndace/python-oldmemo/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ themadbit ];
  };
}
