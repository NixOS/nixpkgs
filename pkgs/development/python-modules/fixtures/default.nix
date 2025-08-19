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
  version = "4.2.4.post1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A0xL0d6qYKW/y2CM5T2Z6Dkr9HyRplNgWuvdagUkjy4=";
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
