{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-vcs,
  testtools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fixtures";
  version = "4.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-t9tkAUcyUT8j0SsMSa5Se6DAwfJmfsl9kTbWcVfrzl0=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  optional-dependencies = {
    streams = [ testtools ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ]
  ++ optional-dependencies.streams;

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = "https://github.com/testing-cabal/fixtures";
    changelog = "https://github.com/testing-cabal/fixtures/blob/${version}/NEWS";
    license = lib.licenses.asl20;
  };
}
