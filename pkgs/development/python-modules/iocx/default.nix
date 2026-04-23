{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pefile,
  pytestCheckHook,
  python-magic,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "iocx";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iocx-dev";
    repo = "iocx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WdUHqQXq/qJyqZ5O9+E777+fQaQowvftDtQ0mj67FHw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pefile
    python-magic
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "iocx" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTests = [
    # Test requires go to be available
    "test_cli_with_real_go_binary"
  ];

  meta = {
    description = "IOC extraction engine for PE binaries and text";
    homepage = "https://github.com/iocx-dev/iocx";
    changelog = "https://github.com/iocx-dev/iocx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
