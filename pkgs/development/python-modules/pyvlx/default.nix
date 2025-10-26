{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyyaml,
  setuptools,
  typing-extensions,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvlx";
  version = "0.2.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = "pyvlx";
    tag = finalAttrs.version;
    hash = "sha256-l+Yfp8s6x+l/1ssL0wgyzd8QbA4ikr+ZUVMdTEaIjYE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
    typing-extensions
    zeroconf
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyvlx" ];

  meta = {
    description = "Python client to work with Velux units";
    longDescription = ''
      PyVLX uses the Velux KLF 200 interface to control io-Homecontrol
      devices, e.g. Velux Windows.
    '';
    homepage = "https://github.com/Julius2342/pyvlx";
    changelog = "https://github.com/Julius2342/pyvlx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
