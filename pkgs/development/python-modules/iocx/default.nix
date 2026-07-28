{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  idna,
  pefile,
  pytestCheckHook,
  python-magic,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "iocx";
  version = "0.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iocx-dev";
    repo = "iocx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j7GApoKh0LBTWMLnapqzRncDFLu+89wLeNmSHxflcks=";
  };

  build-system = [ setuptools ];

  dependencies = [
    idna
    pefile
    python-magic
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "iocx" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # Test requires go to be available
    "test_cli_with_real_go_binary"
    # flaky: timing-sensitive scaling assertion
    "test_filepaths_scaling_behavior"
    "test_crypto_scaling_behavior"
    "test_scaling_behavior"
  ];

  meta = {
    description = "IOC extraction engine for PE binaries and text";
    homepage = "https://github.com/iocx-dev/iocx";
    changelog = "https://github.com/iocx-dev/iocx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
