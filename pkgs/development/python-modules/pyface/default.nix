{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  traits,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyface";
  version = "8.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enthought";
    repo = "pyface";
    tag = finalAttrs.version;
    hash = "sha256-i97cosaFc5GTv5GJgpx1xc81mir/IWljSrAORUapymM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    traits
  ];

  doCheck = false; # Needs X server

  pythonImportsCheck = [ "pyface" ];

  meta = {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/pyface";
    changelog = "https://github.com/enthought/pyface/releases/tag/${finalAttrs.src.tag}";
    maintainers = [ ];
    license = lib.licenses.bsdOriginal;
  };
})
