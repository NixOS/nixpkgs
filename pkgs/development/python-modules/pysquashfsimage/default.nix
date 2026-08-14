{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysquashfsimage";
  version = "0.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "matteomattei";
    repo = "PySquashfsImage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yQnXqCe/nMx+HGgNThdlnyvdNI++6n3iC3c0YvFl0Jk=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "PySquashfsImage" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python library to read Squashfs image files";
    homepage = "https://github.com/matteomattei/PySquashfsImage";
    changelog = "https://github.com/matteomattei/PySquashfsImage/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl3Only
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
