{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pygobject3,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "bluezero";
  version = "0.9.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ukBaz";
    repo = "python-bluezero";
    tag = "v${finalAttrs.version}";
    hash = "sha256-H5760bPdA7NECiOWI7fLCxW3K7+c2L0Y3sa/E/krJJw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pygobject3
  ];

  pythonRelaxDeps = [ "pygobject" ];

  pythonImportsCheck = [
    "bluezero"
  ];

  # Most of the tests are failing due to a missing working dbus instance and bluetooth devices
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple Python interface to Bluez";
    homepage = "https://github.com/ukBaz/python-bluezero";
    changelog = "https://github.com/ukBaz/python-bluezero/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
  };
})
