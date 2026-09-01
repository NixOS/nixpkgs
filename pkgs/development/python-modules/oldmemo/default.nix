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
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Syndace";
    repo = "python-oldmemo";
    tag = "v${version}";
    hash = "sha256-p2VgSNarmVSAj8cuvTKzlIQE0SRJ1BkV91DOv+2B7ek=";
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
