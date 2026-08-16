{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # tests
  versionCheckHook,
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

  # Upstream's pyproject.toml has no [build-system] table (PEP 517), so a source build falls back
  # to setuptools and loses the version.
  postPatch = ''
    printf '\n[build-system]\nrequires = ["poetry-core"]\nbuild-backend = "poetry.core.masonry.api"\n' >> pyproject.toml
  '';

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [ "checksumdir" ];

  # No python tests
  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Simple package to compute a single deterministic hash of the file contents of a directory";
    homepage = "https://github.com/to-mc/checksumdir";
    changelog = "https://github.com/to-mc/checksumdir/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "checksumdir";
  };
})
