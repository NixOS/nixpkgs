{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "fspath";
  version = "20230629";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "return42";
    repo = "fspath";
    tag = finalAttrs.version;
    hash = "sha256-OtJ6PODEYEiUnJriTAKTThSsEtiF7sjMFEu7wFqRR54=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    six
  ];

  pythonImportsCheck = [ "fspath" ];

  meta = {
    description = "Handling path names and executables more comfortable";
    homepage = "https://github.com/return42/fspath";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ skohtv ];
  };
})
