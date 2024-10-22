{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lark,
  lxml,
  oletools,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtfde";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "seamustuohy";
    repo = "RTFDE";
    rev = "refs/tags/${version}";
    hash = "sha256-zmcf9wqlKz55dOIchUC9sgW0PcTCPc52IkbIonOFlmU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lark
    oletools
  ];

  nativeCheckInputs = [
    lxml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "RTFDE" ];

  disabledTests = [
    # Content mismatch
    "test_bin_data_captured"
  ];

  meta = with lib; {
    description = "Library for extracting encapsulated HTML and plain text content from the RTF bodies";
    homepage = "https://github.com/seamustuohy/RTFDE";
    changelog = "https://github.com/seamustuohy/RTFDE/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
