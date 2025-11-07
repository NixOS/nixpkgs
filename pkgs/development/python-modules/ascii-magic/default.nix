{
  lib,
  buildPythonPackage,
  colorama,
  fetchPypi,
  pillow,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ascii-magic";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "ascii_magic";
    inherit version;
    hash = "sha256-PtQaHLFn3u1cz8YotmnzWjoD9nvdctzBi+X/2KJkPYU=";
  };

  propagatedBuildInputs = [
    colorama
    pillow
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "ascii_magic" ];

  preCheck = ''
    cd tests
  '';

  disabledTests = [
    # Test requires network access
    "test_from_url"
    "test_quick_test"
    "test_wrong_url"
    # No clipboard in the sandbox
    "test_from_clipboard"
  ];

  meta = with lib; {
    description = "Python module to converts pictures into ASCII art";
    homepage = "https://github.com/LeandroBarone/python-ascii_magic";
    changelog = "https://github.com/LeandroBarone/python-ascii_magic#changelog";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
