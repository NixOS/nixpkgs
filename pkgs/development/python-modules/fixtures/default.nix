{
  lib,
  buildPythonPackage,
  fetchPypi,
  pbr,
  setuptools,
  testtools,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fixtures";
  version = "4.1.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-grHF5p9hVSbvbAZxiKHmxgZ99/iDMlCcmfi4/buXdvM=";
  };

  nativeBuildInputs = [
    pbr
    setuptools
  ];

  propagatedBuildInputs = [ pbr ];

  passthru.optional-dependencies = {
    streams = [ testtools ];
  };

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ] ++ passthru.optional-dependencies.streams;

  meta = {
    description = "Reusable state for writing clean tests and more";
    homepage = "https://pypi.org/project/fixtures/";
    changelog = "https://github.com/testing-cabal/fixtures/blob/${version}/NEWS";
    license = lib.licenses.asl20;
  };
}
