{
  lib,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "cometblue-lite";
  version = "0.7.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "neffs";
    repo = "python-cometblue_lite";
    tag = finalAttrs.version;
    hash = "sha256-Cjd7PdZ2/neRr1jStDY5iJaGMJ/srnFmCea8aLNan6g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "cometblue_lite" ];

  meta = {
    description = "Module for Eurotronic Comet Blue thermostats";
    homepage = "https://github.com/neffs/python-cometblue_lite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
