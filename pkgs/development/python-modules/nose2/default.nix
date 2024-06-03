{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # optional-dependencies
  coverage,

  # tests
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.14.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-f48Dohyd4sMwFZM6/O9yv45KLV3+w7QAkih95uQbCTo=";
  };

  nativeBuildInputs = [ setuptools ];

  passthru.optional-dependencies = {
    coverage = [ coverage ];
  };

  pythonImportsCheck = [ "nose2" ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    unittestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/nose-devs/nose2/blob/${version}/docs/changelog.rst";
    description = "Test runner for Python";
    mainProgram = "nose2";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
