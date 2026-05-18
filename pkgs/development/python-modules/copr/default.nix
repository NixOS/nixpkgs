{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  filelock,
  munch,
  requests,
  requests-gssapi,
  requests-toolbelt,
  setuptools,
}:
buildPythonPackage rec {
  pname = "copr";
  version = "2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-copr";
    repo = "copr";
    tag = "copr-cli-2.5-1";
    hash = "sha256-/eFno+EXhZ86g8++um620I1/Zn1niS5yYzn+ZxcR/eg=";
  };

  sourceRoot = "${src.name}/python";

  build-system = [ setuptools ];

  dependencies = [
    filelock
    munch
    requests
    requests-gssapi
    requests-toolbelt
    setuptools
  ];

  pythonImportsCheck = [ "copr" ];

  meta = {
    description = "Python client for the Fedora Copr build system";
    homepage = "https://github.com/fedora-copr/copr";
    changelog = "https://github.com/fedora-copr/copr/releases/tag/${src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ caniko ];
  };
}
