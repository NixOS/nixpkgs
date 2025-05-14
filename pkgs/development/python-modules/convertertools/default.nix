{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  cython,
  poetry-core,
  setuptools,

  # checks
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "convertertools";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "convertertools";
    tag = "v${version}";
    hash = "sha256-Oy1Nf/mS2Lr2N7OB27QDlW+uuhafib2kolEXzXLppWU=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  build-system = [
    cython
    poetry-core
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "convertertools" ];

  meta = with lib; {
    description = "Tools for converting python data types";
    homepage = "https://github.com/bluetooth-devices/convertertools";
    changelog = "https://github.com/bluetooth-devices/convertertools/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
