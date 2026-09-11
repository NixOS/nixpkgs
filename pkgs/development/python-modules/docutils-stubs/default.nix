{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  docutils,
}:

buildPythonPackage (finalAttrs: {
  pname = "docutils-stubs";
  version = "0.0.22";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tk0miya";
    repo = "docutils-stubs";
    tag = finalAttrs.version;
    hash = "sha256-ng/f5e8ElFGNqtpdiQsv897TNkJ4gd++HAxON2l+80s=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    docutils
  ];

  # Module doesn't have tests
  doCheck = false;

  meta = {
    description = "PEP 561 based Type information for docutils";
    homepage = "https://github.com/tk0miya/docutils-stubs";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
