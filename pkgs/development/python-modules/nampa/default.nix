{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  unstableGitUpdater,
}:

buildPythonPackage {
  pname = "nampa";
  version = "1.0-unstable-2026-07-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thebabush";
    repo = "nampa";
    rev = "4ab5b33e767caef3ae1d64eec3cb894ba2f287f8";
    hash = "sha256-sCI4QaG/hHZKIw7kAK9/OLo5MFZyR0lA3t8xQiGFHOY=";
  };

  build-system = [ setuptools ];

  # Not used for binaryninja as plugin
  doCheck = false;

  pythonImportsCheck = [ "nampa" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Python implementation of the FLIRT technology";
    homepage = "https://github.com/thebabush/nampa";
    changelog = "https://github.com/thebabush/nampa/commits/cb6a63aae64324f57bdc296064bc6aa2b99ff99a/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
