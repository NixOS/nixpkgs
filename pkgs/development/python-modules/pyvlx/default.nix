{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  typing-extensions,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvlx";
  version = "0.2.30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Julius2342";
    repo = "pyvlx";
    tag = finalAttrs.version;
    hash = "sha256-owrWYBAb/5JAangGwt56gdjJf99C3i04IiKAh1P/MYY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools-scm>=8.0" "setuptools-scm"
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

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
