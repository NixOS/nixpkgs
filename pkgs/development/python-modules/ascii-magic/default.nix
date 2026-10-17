{
  lib,
  buildPythonPackage,
  colorama,
  fetchFromGitHub,
  pillow,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ascii-magic";
  version = "2.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LeandroBarone";
    repo = "python-ascii_magic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-werCg7LW7MKMoYp/QxZU74MSc6WmscwWfvGRG4Dn60c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ascii_magic" ];

  preCheck = ''
    ln -s ascii_magic/tests/*.{jpg,png} ./
  '';

  disabledTests = [
    # Test requires network access
    "test_from_url"
    "test_quick_test"
    "test_wrong_url"
    # No clipboard in the sandbox
    "test_from_clipboard"
  ];

  meta = {
    description = "Python module to converts pictures into ASCII art";
    homepage = "https://github.com/LeandroBarone/python-ascii_magic";
    changelog = "https://github.com/LeandroBarone/python-ascii_magic#changelog";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
