{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  serialio,
  sockio,
}:

buildPythonPackage (finalAttrs: {
  pname = "connio";
  version = "0.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tiagocoutinho";
    repo = "connio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fPM7Ya69t0jpZhKM2MTk6BwjvoW3a8SV3k000LB9Ypo=";
  };

  build-system = [ setuptools ];

  dependencies = [
    serialio
    sockio
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "connio" ];

  meta = {
    description = "Library for concurrency agnostic communication";
    homepage = "https://github.com/tiagocoutinho/connio";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fab ];
  };
})
