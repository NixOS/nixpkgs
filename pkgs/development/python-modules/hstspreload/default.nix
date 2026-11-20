{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "hstspreload";
  version = "2026.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "hstspreload";
    tag = finalAttrs.version;
    hash = "sha256-DCoaWr+io5muRDF78sfG6LnTgfASpgVkVrGvTLJaMWQ=";
  };

  build-system = [ setuptools ];

  # Tests require network connection
  doCheck = false;

  pythonImportsCheck = [ "hstspreload" ];

  meta = {
    description = "Chromium HSTS Preload list";
    homepage = "https://github.com/sethmlarson/hstspreload";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
