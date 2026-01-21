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

buildPythonPackage rec {
  pname = "pyvlx";
  version = "0.2.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = "pyvlx";
    tag = version;
    hash = "sha256-FOchtl3HDByHIBRh0MXYnQYh6opzkcHOOYaINmMPu7w=";
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
    changelog = "https://github.com/Julius2342/pyvlx/releases/tag/${src.tag}";
    license = lib.licenses.lgpl2Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
