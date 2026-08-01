{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "checksumdir";
  version = "1.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "to-mc";
    repo = "checksumdir";
    tag = finalAttrs.version;
    hash = "sha256-rOHRJAK+Or8bwAtzpbINdnEjK3WQcU+4sEZI91tMvAk=";
  };

  build-system = [
    setuptools
  ];

  doCheck = false; # Package does not contain tests
  pythonImportsCheck = [ "checksumdir" ];

  meta = {
    description = "Simple package to compute a single deterministic hash of the file contents of a directory";
    homepage = "https://github.com/to-mc/checksumdir";
    changelog = "https://github.com/to-mc/checksumdir/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "checksumdir";
  };
})
