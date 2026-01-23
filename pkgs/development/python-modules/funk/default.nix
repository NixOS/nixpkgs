{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  precisely,
  gitUpdater,
}:

buildPythonPackage rec {
  pname = "funk";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mwilliamson";
    repo = "funk";
    tag = version;
    hash = "sha256-dEq3zyA8rtNt0sui2TfQ3OUSCZ0XDMOdthcqt/QrCsU=";
  };

  build-system = [ setuptools ];

  dependencies = [ precisely ];

  pythonImportsCheck = [ "funk" ];

  # Disabling tests, they rely on Nose which is outdated and not supported
  doCheck = false;

  passthru.updateScripts = gitUpdater { };

  meta = {
    description = "Mocking framework for Python, influenced by JMock";
    homepage = "https://github.com/mwilliamson/funk";
    changelog = "https://github.com/mwilliamson/funk/blob/${src.tag}/NEWS";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
