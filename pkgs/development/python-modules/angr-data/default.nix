{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "angr-data";
  version = "0.1.1";
  pyproject = true;
  __structuredAttrs = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "angr";
    repo = "angr-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DVXVBCWcpB4rEvtOl7Y94CbGu2S/jaIVmxiGDMJuxf4=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "angr_data" ];

  meta = {
    description = "Function and type prototype data used by angr";
    homepage = "https://github.com/angr/angr-data";
    changelog = "https://github.com/angr/angr-data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      connornelson
      fab
    ];
  };
})
